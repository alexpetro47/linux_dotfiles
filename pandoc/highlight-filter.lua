-- Filter to handle [highlight] syntax and ~~strikethrough~~ with GFM reader
-- GFM splits [text with spaces] into multiple Str elements

-- Handle Strikeout elements that pandoc creates from ~~text~~
function Strikeout(elem)
  -- Convert to LaTeX \sout command for better rendering
  local content = pandoc.utils.stringify(elem.content)
  return pandoc.RawInline('latex', '\\sout{' .. content .. '}')
end

function Inlines(inlines)
  local result = {}
  local i = 1
  
  while i <= #inlines do
    local elem = inlines[i]
    
    if elem.t == "Str" then
      local text = elem.text
      
      -- Check if this starts with [
      if text:match("^%[") then
        -- Look for the closing ]
        local highlight_parts = {}
        local found_close = false
        local j = i
        
        -- Check if the closing ] is in the same element
        if text:match("^%[.*%]") then
          -- Complete highlight in one element
          local content = text:match("^%[(.*)%]$")
          if content then
            -- Perfect match [content]
            table.insert(result, pandoc.RawInline('latex', '\\hl{' .. content .. '}'))
            found_close = true
          else
            -- Has more text after ]
            local highlighted, rest = text:match("^%[(.-)%](.*)$")
            if highlighted then
              table.insert(result, pandoc.RawInline('latex', '\\hl{' .. highlighted .. '}'))
              if rest ~= "" then
                table.insert(result, pandoc.Str(rest))
              end
              found_close = true
            end
          end
        else
          -- Multi-element highlight
          -- Remove leading [ from first part
          local first_part = text:sub(2)
          if first_part ~= "" then
            table.insert(highlight_parts, first_part)
          end
          
          j = i + 1
          while j <= #inlines and not found_close do
            local next_elem = inlines[j]
            
            if next_elem.t == "Str" then
              local next_text = next_elem.text
              
              -- Check if this element contains ]
              if next_text:find("%]") then
                local before_bracket, after_bracket = next_text:match("^(.-)%](.*)$")
                if before_bracket then
                  table.insert(highlight_parts, before_bracket)
                end
                
                -- Combine all parts
                local combined = table.concat(highlight_parts, "")
                table.insert(result, pandoc.RawInline('latex', '\\hl{' .. combined .. '}'))
                
                -- Add remaining text after ]
                if after_bracket and after_bracket ~= "" then
                  table.insert(result, pandoc.Str(after_bracket))
                end
                
                found_close = true
                i = j
              else
                -- Add entire string to highlight
                table.insert(highlight_parts, next_text)
              end
            elseif next_elem.t == "Space" then
              -- Add space between words
              table.insert(highlight_parts, " ")
            else
              -- Other element type, stop looking
              break
            end
            
            j = j + 1
          end
        end
        
        if not found_close then
          -- No closing bracket found, treat as normal text
          table.insert(result, elem)
        end
      else
        -- Doesn't start with [, add as-is
        table.insert(result, elem)
      end
    else
      -- Not a Str element
      table.insert(result, elem)
    end
    
    i = i + 1
  end
  
  return result
end