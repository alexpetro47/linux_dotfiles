#!/bin/bash

# Find2 MVP - Comprehensive code discovery tool
find2() {
    local query="$1"
    
    if [[ -z "$query" ]]; then
        echo "Usage: find <query>"
        echo "Example: find database"
        return 1
    fi
    
    echo "=== 🔍 COMPREHENSIVE DISCOVERY: $query ==="
    echo ""
    
    # Create temporary files for parallel execution
    local tmp_dir="/tmp/find$$"
    mkdir -p "$tmp_dir"
    
    # Execute all tools in parallel
    {
        search_symbols "$query" > "$tmp_dir/symbols.txt" &
        search_content "$query" > "$tmp_dir/content.txt" &
        search_structure "$query" > "$tmp_dir/structure.txt" &
        # search_semantic "$query" > "$tmp_dir/semantic.txt" &
        wait
    }
    
    # Format and display results
    format_output "$tmp_dir" "$query"
    
    # Cleanup
    rm -rf "$tmp_dir"
}

# Extract multi-line signatures based on symbol type and language
extract_multiline_signature() {
    local file="$1"
    local line_num="$2"
    local category="$3"
    local symbol="$4"
    local file_ext="${file##*.}"
    
    case "$category" in
        function|method)
            case "$file_ext" in
                py)
                    extract_python_function_signature "$file" "$line_num"
                    ;;
                js|ts|jsx|tsx)
                    extract_js_function_signature "$file" "$line_num"
                    ;;
                *)
                    # Fallback to single line with extended length
                    sed -n "${line_num}p" "$file" 2>/dev/null | sed 's/^[[:space:]]*//' | cut -c1-120
                    ;;
            esac
            ;;
        class)
            case "$file_ext" in
                py)
                    extract_python_class_signature "$file" "$line_num"
                    ;;
                *)
                    # Fallback to single line
                    sed -n "${line_num}p" "$file" 2>/dev/null | sed 's/^[[:space:]]*//' | cut -c1-120
                    ;;
            esac
            ;;
        *)
            # Variables and other symbols - keep single line
            local signature=$(sed -n "${line_num}p" "$file" 2>/dev/null | sed 's/^[[:space:]]*//' | cut -c1-100)
            [[ ${#signature} -gt 97 ]] && signature="${signature:0:97}..."
            echo "$signature"
            ;;
    esac
}

# Extract complete Python function signature
extract_python_function_signature() {
    local file="$1"
    local line_num="$2"
    
    # Find the end of the function signature (look for closing parenthesis + colon)
    local sig_start=$line_num
    local sig_end=$line_num
    local max_lines=10
    
    # Look ahead to find the complete signature
    local temp_line=$sig_start
    while [[ $temp_line -le $((sig_start + max_lines)) ]]; do
        local line_content=$(sed -n "${temp_line}p" "$file" 2>/dev/null)
        if [[ "$line_content" =~ .*\).*:[[:space:]]*$ ]]; then
            sig_end=$temp_line
            break
        fi
        temp_line=$((temp_line + 1))
    done
    
    # Extract and format the complete signature
    local full_signature=$(sed -n "${sig_start},${sig_end}p" "$file" 2>/dev/null | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g')
    
    # Trim and limit length with smart truncation
    full_signature=$(echo "$full_signature" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    
    if [[ ${#full_signature} -gt 150 ]]; then
        # Try to truncate at a reasonable point (after a parameter)
        local truncated=$(echo "$full_signature" | cut -c1-147)
        if [[ "$truncated" =~ .*,[[:space:]]*[^,]*$ ]]; then
            # Cut at the last complete parameter
            truncated=$(echo "$truncated" | sed 's/,[[:space:]]*[^,]*$//')
            echo "${truncated}, ...)"
        else
            echo "${truncated}..."
        fi
    else
        echo "$full_signature"
    fi
}

# Extract complete Python class signature
extract_python_class_signature() {
    local file="$1"
    local line_num="$2"
    
    local class_line=$(sed -n "${line_num}p" "$file" 2>/dev/null)
    
    # Check if class definition spans multiple lines (has opening parenthesis but no closing)
    if [[ "$class_line" =~ class.*\([^\)]*$ ]]; then
        local sig_start=$line_num
        local sig_end=$line_num
        local max_lines=5
        
        # Look ahead to find the complete class signature
        local temp_line=$sig_start
        while [[ $temp_line -le $((sig_start + max_lines)) ]]; do
            local line_content=$(sed -n "${temp_line}p" "$file" 2>/dev/null)
            if [[ "$line_content" =~ .*\).*:[[:space:]]*$ ]]; then
                sig_end=$temp_line
                break
            fi
            temp_line=$((temp_line + 1))
        done
        
        # Extract and format the complete signature
        local full_signature=$(sed -n "${sig_start},${sig_end}p" "$file" 2>/dev/null | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g')
        full_signature=$(echo "$full_signature" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    else
        # Single line class definition
        local full_signature=$(echo "$class_line" | sed 's/^[[:space:]]*//')
    fi
    
    # Limit length
    if [[ ${#full_signature} -gt 120 ]]; then
        echo "${full_signature:0:117}..."
    else
        echo "$full_signature"
    fi
}

# Extract JavaScript/TypeScript function signature
extract_js_function_signature() {
    local file="$1"
    local line_num="$2"
    
    # Check for arrow functions, regular functions, method definitions
    local func_line=$(sed -n "${line_num}p" "$file" 2>/dev/null)
    
    if [[ "$func_line" =~ =\>[[:space:]]*\{ ]] || [[ "$func_line" =~ function.*\{$ ]]; then
        # Single line function
        echo "$func_line" | sed 's/^[[:space:]]*//' | cut -c1-120
    else
        # Multi-line function - look for opening brace
        local sig_start=$line_num
        local sig_end=$line_num
        local max_lines=8
        
        local temp_line=$sig_start
        while [[ $temp_line -le $((sig_start + max_lines)) ]]; do
            local line_content=$(sed -n "${temp_line}p" "$file" 2>/dev/null)
            if [[ "$line_content" =~ .*\{[[:space:]]*$ ]]; then
                sig_end=$temp_line
                break
            fi
            temp_line=$((temp_line + 1))
        done
        
        # Extract and format
        local full_signature=$(sed -n "${sig_start},${sig_end}p" "$file" 2>/dev/null | tr '\n' ' ' | sed 's/[[:space:]]\+/ /g')
        full_signature=$(echo "$full_signature" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
        
        if [[ ${#full_signature} -gt 120 ]]; then
            echo "${full_signature:0:117}..."
        else
            echo "$full_signature"
        fi
    fi
}

# Symbol search with ctags - extracts symbols and maps to categories
search_symbols() {
    local query="$1"
    
    # Generate ctags if needed
    if [[ ! -f ".m/tags" ]] || [[ $(find . -name "*.py" -o -name "*.sh" -newer ".m/tags" | wc -l) -gt 0 ]]; then
        mkdir -p .m
        ctags -f .m/tags -R --languages=Sh,Python,JavaScript,TypeScript --exclude=".venv" --exclude="node_modules" . 2>/dev/null
    fi
    
    # Search ctags for symbols matching query
    if [[ -f ".m/tags" ]]; then
        grep -v "^!" .m/tags | grep -i "$query" | while IFS=$'\t' read -r symbol file pattern kind_info; do
            # Extract kind from kind_info (format: ;"<tab>kind)
            local kind=$(echo "$kind_info" | sed 's/.*"//' | cut -c1)
            
            # Extract line number from ctags pattern field first (most accurate)
            local line_num=$(echo "$pattern" | grep -o 'line:[0-9]*' | cut -d: -f2)
            
            # If no line info in pattern, try extracting from search pattern itself
            if [[ -z "$line_num" ]]; then
                # Remove the /^ and $/ wrapping from ctags pattern and search for it
                local search_pattern=$(echo "$pattern" | sed 's|^/\^||' | sed 's|\$/.*||' | sed 's/\\/\\\\/g')
                line_num=$(rg -n -F "$search_pattern" "$file" 2>/dev/null | head -1 | cut -d: -f1)
            fi
            
            # If still no match, try broader patterns based on symbol type
            if [[ -z "$line_num" ]]; then
                case "$kind" in
                    f|m) # functions/methods - handle various function syntaxes
                        line_num=$(rg -n "^\\s*(def|function|fn)\\s+${symbol}\\b" "$file" 2>/dev/null | head -1 | cut -d: -f1)
                        [[ -z "$line_num" ]] && line_num=$(rg -n "^\\s*${symbol}\\s*\\(" "$file" 2>/dev/null | head -1 | cut -d: -f1)
                        [[ -z "$line_num" ]] && line_num=$(rg -n "\\b${symbol}\\s*=" "$file" 2>/dev/null | head -1 | cut -d: -f1)
                        ;;
                    c) # classes
                        line_num=$(rg -n "^\\s*class\\s+${symbol}\\b" "$file" 2>/dev/null | head -1 | cut -d: -f1)
                        ;;
                    v) # variables
                        line_num=$(rg -n "^\\s*(local\\s+|readonly\\s+|declare\\s+|export\\s+|const\\s+|let\\s+|var\\s+)?${symbol}\\s*=" "$file" 2>/dev/null | head -1 | cut -d: -f1)
                        ;;
                    *) # general symbol search
                        line_num=$(rg -n "\\b${symbol}\\b" "$file" 2>/dev/null | head -1 | cut -d: -f1)
                        ;;
                esac
            fi
            
            # Last resort fallback
            [[ -z "$line_num" ]] && line_num="1"
            
            # Map ctags kind to find2 categories
            local category="symbol"
            case "$kind" in
                c) category="class" ;;
                f) category="function" ;;
                m) category="method" ;;
                v) category="variable" ;;
                i) category="interface" ;;
                s) category="struct" ;;
                e) category="enum" ;;
                t) category="typedef" ;;
                d) category="macro" ;;
                n) category="namespace" ;;
                h) category="header" ;;
                *) category="symbol" ;;
            esac
            
            # Get the actual line content for signature with multi-line support
            if [[ -f "$file" ]]; then
                local signature=$(extract_multiline_signature "$file" "$line_num" "$category" "$symbol")
                echo "SYMBOL|$category|$file|$line_num|$signature"
            fi
        done
    fi
    
    # Additional ripgrep-based variable detection with more flexible patterns
    rg "^[[:space:]]*(local|readonly|declare|export)?[[:space:]]*.*$query[a-zA-Z0-9_]*[[:space:]]*=" \
        --type-add 'code:*.{py,js,ts,jsx,tsx,sh,bash,zsh,go,rs,c,cpp,h,hpp,java,rb,php}' \
        -t code \
        --line-number \
        --no-heading \
        . 2>/dev/null | \
    while IFS=':' read -r file line content; do
        # Skip if this looks like a function definition or comment
        [[ "$content" =~ ^[[:space:]]*# ]] && continue
        [[ "$content" =~ \(\) ]] && continue
        
        # Clean up content for display with improved length handling
        local clean_content=$(echo "$content" | sed 's/^[[:space:]]*//' | cut -c1-100)
        [[ ${#content} -gt 97 ]] && clean_content="${clean_content:0:97}..."
        
        # Extract variable name from the line more accurately
        local var_name=$(echo "$content" | sed 's/^[[:space:]]*\(local\|readonly\|declare\|export\)*[[:space:]]*//' | sed 's/[[:space:]]*=.*//' | sed 's/[[:space:]]*$//')
        
        echo "SYMBOL|variable|$file|$line|$clean_content"
    done
    
    # Search for const/let/var declarations (JavaScript/TypeScript)
    rg "^[[:space:]]*(const|let|var)[[:space:]]+.*$query" \
        --type js --type ts \
        --line-number \
        --no-heading \
        . 2>/dev/null | \
    while IFS=':' read -r file line content; do
        local clean_content=$(echo "$content" | sed 's/^[[:space:]]*//' | cut -c1-100)
        [[ ${#content} -gt 97 ]] && clean_content="${clean_content:0:97}..."
        
        local var_name=$(echo "$content" | sed 's/^[[:space:]]*\(const\|let\|var\)[[:space:]]*//' | sed 's/[[:space:]]*=.*//' | sed 's/[[:space:]]*:.*//')
        
        echo "SYMBOL|variable|$file|$line|$clean_content"
    done
}

# Content search with ripgrep - finds text content in files
search_content() {
    local query="$1"
    
    # Search for content with line numbers
    rg "$query" \
        --type-add 'code:*.{py,js,ts,jsx,tsx,go,rs,c,cpp,h,hpp,java,rb,php,swift,kt,scala,clj,hs,ml,fs,pl,lua,r,m,mm,cs,vb,sql,sh,zsh,fish,ps1,bat,cmd}' \
        --type-add 'docs:*.{md,txt,rst,adoc,org}' \
        --type-add 'config:*.{json,yaml,yml,toml,ini,conf,cfg,xml,properties}' \
        -t code -t docs -t config \
        --smart-case \
        --line-number \
        --no-heading \
        . 2>/dev/null | \
    while IFS=':' read -r file line content; do
        # Clean up content for display  
        local clean_content=$(echo "$content" | sed 's/^[[:space:]]*//' | cut -c1-100)
        [[ ${#content} -gt 97 ]] && clean_content="${clean_content:0:97}..."
        
        echo "CONTENT|content|$file|$line|$clean_content"
    done
}

# Structure search with fd-find - finds files and directories
search_structure() {
    local query="$1"
    
    # Search for file and directory names
    fd "$query" . \
        --type f \
        --type d \
        --exclude .git \
        --exclude .venv \
        --exclude node_modules \
        --exclude __pycache__ \
        2>/dev/null | \
    while read -r path; do
        if [[ -d "$path" ]]; then
            echo "STRUCTURE|directory|$path|0|$path/"
        else
            echo "STRUCTURE|file|$path|0|$path"
        fi
    done
}

# Semantic search integration - processes sem-search chunks
search_semantic() {
    local query="$1"
    
    # Check if sem-search is available
    if ! command -v sem-search >/dev/null 2>&1; then
        echo "# sem-search not available" >/dev/stderr
        return 0
    fi
    
    # Run semantic search and process results
    sem-search "$query" 2>/dev/null | \
    awk '
    /^Result [0-9]+ \(similarity: [0-9.]+\)/ {
        similarity = $3
        gsub(/[()]/, "", similarity)
        getline
        if ($0 ~ /^File: /) {
            file_info = substr($0, 7)  # Remove "File: " prefix
            split(file_info, parts, ":")
            file = parts[1]
            if (parts[2] ~ /-/) {
                split(parts[2], range, "-")
                start_line = range[1]
                end_line = range[2]
            } else {
                start_line = parts[2]
                end_line = start_line
            }
            
            # Read the chunk content
            chunk_content = ""
            getline  # skip separator
            while (getline && $0 != "----------------------------------------") {
                chunk_content = chunk_content $0 "\n"
            }
            
            # Extract symbols from chunk using patterns
            split(chunk_content, lines, "\n")
            for (i in lines) {
                line = lines[i]
                line_num = start_line + i - 1
                
                # Extract class definitions
                if (match(line, /^[[:space:]]*(class[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*)/)) {
                    class_match = substr(line, RSTART, RLENGTH)
                    gsub(/^[[:space:]]*/, "", class_match)
                    print "SEMANTIC|class|" file "|" line_num "|" class_match " [" similarity "]"
                }
                
                # Extract function definitions  
                if (match(line, /^[[:space:]]*(def[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*)/)) {
                    func_match = substr(line, RSTART, RLENGTH)
                    gsub(/^[[:space:]]*/, "", func_match)
                    print "SEMANTIC|function|" file "|" line_num "|" func_match " [" similarity "]"
                }
                
                # Extract variable assignments with enhanced patterns
                # Basic assignment: var=value
                if (match(line, /^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*=[[:space:]]*[^=]/)) {
                    var_match = line
                    gsub(/^[[:space:]]*/, "", var_match)
                    if (length(var_match) > 50) var_match = substr(var_match, 1, 47) "..."
                    print "SEMANTIC|variable|" file "|" line_num "|" var_match " [" similarity "]"
                }
                
                # Local variables: local var=value
                if (match(line, /^[[:space:]]*local[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*=/)) {
                    var_match = line
                    gsub(/^[[:space:]]*/, "", var_match)
                    if (length(var_match) > 50) var_match = substr(var_match, 1, 47) "..."
                    print "SEMANTIC|variable|" file "|" line_num "|" var_match " [" similarity "]"
                }
                
                # Readonly/declare variables
                if (match(line, /^[[:space:]]*(readonly|declare)[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*=/)) {
                    var_match = line
                    gsub(/^[[:space:]]*/, "", var_match)
                    if (length(var_match) > 50) var_match = substr(var_match, 1, 47) "..."
                    print "SEMANTIC|variable|" file "|" line_num "|" var_match " [" similarity "]"
                }
                
                # Array assignments: arr[index]=value or arr=(values)
                if (match(line, /^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*(\[.*\]|[[:space:]]*\().*=/)) {
                    var_match = line
                    gsub(/^[[:space:]]*/, "", var_match)
                    if (length(var_match) > 50) var_match = substr(var_match, 1, 47) "..."
                    print "SEMANTIC|variable|" file "|" line_num "|" var_match " [" similarity "]"
                }
                
                # Environment exports: export VAR=value
                if (match(line, /^[[:space:]]*export[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*=/)) {
                    var_match = line
                    gsub(/^[[:space:]]*/, "", var_match)
                    if (length(var_match) > 50) var_match = substr(var_match, 1, 47) "..."
                    print "SEMANTIC|variable|" file "|" line_num "|" var_match " [" similarity "]"
                }
                
                # Python variables: var = value (with spaces)
                if (match(line, /^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]+=[[:space:]]+/)) {
                    var_match = line
                    gsub(/^[[:space:]]*/, "", var_match)
                    if (length(var_match) > 50) var_match = substr(var_match, 1, 47) "..."
                    print "SEMANTIC|variable|" file "|" line_num "|" var_match " [" similarity "]"
                }
                
                # JavaScript const/let/var declarations
                if (match(line, /^[[:space:]]*(const|let|var)[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*=/)) {
                    var_match = line
                    gsub(/^[[:space:]]*/, "", var_match)
                    if (length(var_match) > 50) var_match = substr(var_match, 1, 47) "..."
                    print "SEMANTIC|variable|" file "|" line_num "|" var_match " [" similarity "]"
                }
            }
            
            # Also add the file path as structure if similarity is high
            if (similarity + 0 > 0.3) {
                print "SEMANTIC|file|" file "|0|" file " [" similarity "]"
            }
        }
    }'
}

# Format and display all results in categorized output
format_output() {
    local tmp_dir="$1"
    local query="$2"
    
    # Combine all results and deduplicate
    local all_results="$tmp_dir/all_results.txt"
    cat "$tmp_dir"/*.txt 2>/dev/null | sort -t'|' -k3,3 -k4,4n > "$all_results"
    
    # Remove duplicates by file:line combination, keeping first occurrence
    local dedup_results="$tmp_dir/dedup_results.txt"
    awk -F'|' '!seen[$3":"$4]++' "$all_results" > "$dedup_results"
    
    # Display symbols
    echo "📍 SYMBOLS"
    grep "^SYMBOL\|^SEMANTIC" "$dedup_results" | grep -v "content\|file\|directory" | \
    while IFS='|' read -r source category file line signature; do
        # Calculate prefix for consistent formatting
        local file_line_info="$file:$line"
        local prefix_format="%-8s %s "
        
        # Always use single line with proper wrapping
        printf "$prefix_format%s\n" "$category" "$file_line_info" "$signature"
    done
    
    echo ""
    
    # Display content
    echo "📝 CONTENT"  
    grep "^CONTENT" "$dedup_results" | \
    while IFS='|' read -r source category file line content; do
        printf "%s:%-4s %s\n" "$file" "$line" "$content"
    done
    
    echo ""
    
    # Display structure
    echo "🏗️ STRUCTURE"
    grep "^STRUCTURE\|^SEMANTIC.*file" "$dedup_results" | \
    while IFS='|' read -r source category file line path; do
        echo "$path"
    done | sort -u
}
