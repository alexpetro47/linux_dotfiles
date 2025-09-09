function Para(elem)
  -- Convert paragraphs that contain only "\\newpage" to raw LaTeX
  if #elem.content == 1 and elem.content[1].t == "Str" and elem.content[1].text == "\\newpage" then
    return pandoc.RawBlock("latex", "\\newpage")
  end
  
  -- Also handle the case where it might be split
  local text = pandoc.utils.stringify(elem)
  if text == "\\newpage" then
    return pandoc.RawBlock("latex", "\\newpage")
  end
end

function RawBlock(elem)
  -- Pass through any existing raw LaTeX blocks
  if elem.format == "latex" and elem.text:match("\\newpage") then
    return elem
  end
end
