#!/bin/bash
# Memory MCP replacement functions

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






arch() {
    local threshold="${1:-5}"
    local filter_query="${2:-""}"
    
    echo "=== 🔗 ARCH ANALYSIS (threshold: $threshold) ==="
    
    # Collect all results first
    local temp_file="/tmp/arch_results_$$"
    find . -name "*.py" -type f -not -path "./.venv/*" -not -path "./venv/*" -not -path "*/__pycache__/*" | while read file; do
        local imports=$(grep -c "^\s*\(import\|from\)" "$file" 2>/dev/null || echo 0)
        local calls=$(grep -o '[a-zA-Z_][a-zA-Z0-9_]*\.[a-zA-Z_][a-zA-Z0-9_]*(' "$file" 2>/dev/null | wc -l || echo 0)
        local total=$((${imports:-0} + ${calls:-0}))
        
        if [[ $total -ge $threshold ]]; then
            local severity="LOW"
            local icon="ℹ️"
            local problem_lines=""
            local hot_functions=""
            
            # Set severity and icon based on total
            if [[ $total -ge 15 ]]; then
                severity="CRITICAL"
                icon="🔴"
            elif [[ $total -ge 10 ]]; then
                severity="HIGH"
                icon="🚨"
            elif [[ $total -ge 7 ]]; then
                severity="MEDIUM"
                icon="⚠️"
            fi
            
            # Get specific locations for high coupling files
            if [[ $total -ge 10 ]]; then
                problem_lines=$(grep -n '[a-zA-Z_][a-zA-Z0-9_]*\.[a-zA-Z_][a-zA-Z0-9_]*(' "$file" 2>/dev/null | head -3 | cut -d: -f1 | tr '\n' ',' | sed 's/,$//')
                hot_functions=$(ast-grep --pattern 'def $NAME($$$): $$$' --lang python "$file" --json=compact 2>/dev/null | \
                    jq -r '.[] | select(.text | test("[a-zA-Z_][a-zA-Z0-9_]*\\.[a-zA-Z_][a-zA-Z0-9_]*\\(")) | .text | match("def ([a-zA-Z_][a-zA-Z0-9_]*)").captures[0].string' 2>/dev/null | \
                    head -2 | tr '\n' ',' | sed 's/,$//')
            fi
            
            printf "%s|%s|%d|%d|%d|%s|%s\n" "$severity" "$icon" "$total" "$imports" "$calls" "$file" "$problem_lines" "$hot_functions"
        fi
    done > "$temp_file"
    
    # Group and display by severity
    local critical_files=$(grep "^CRITICAL" "$temp_file" | wc -l)
    local high_files=$(grep "^HIGH" "$temp_file" | wc -l)
    local medium_files=$(grep "^MEDIUM" "$temp_file" | wc -l)
    local low_files=$(grep "^LOW" "$temp_file" | wc -l)
    
    printf "\n📊 SUMMARY: %d Critical, %d High, %d Medium, %d Low\n\n" "$critical_files" "$high_files" "$medium_files" "$low_files"
    
    # Display CRITICAL files
    if [[ $critical_files -gt 0 ]]; then
        echo "🔴 CRITICAL ARCH (15+ dependencies):"
        grep "^CRITICAL" "$temp_file" | sort -t'|' -k3 -nr | while IFS='|' read -r severity icon total imports calls file problem_lines hot_functions; do
            if [[ -n "$problem_lines" ]]; then
                printf "  %s %s: %d imports, %d calls\n     📍 Lines: %s\n" "$icon" "$file" "$imports" "$calls" "$problem_lines"
            else
                printf "  %s %s: %d imports, %d calls\n" "$icon" "$file" "$imports" "$calls"
            fi
        done
        echo ""
    fi
    
    # Display HIGH files
    if [[ $high_files -gt 0 ]]; then
        echo "🚨 HIGH ARCH (10-14 dependencies):"
        grep "^HIGH" "$temp_file" | sort -t'|' -k3 -nr | while IFS='|' read -r severity icon total imports calls file problem_lines hot_functions; do
            if [[ -n "$problem_lines" ]]; then
                printf "  %s %s: %d imports, %d calls\n     📍 Lines: %s\n" "$icon" "$file" "$imports" "$calls" "$problem_lines"
            else
                printf "  %s %s: %d imports, %d calls\n" "$icon" "$file" "$imports" "$calls"
            fi
        done
        echo ""
    fi
    
    # Display MEDIUM files
    if [[ $medium_files -gt 0 ]]; then
        echo "⚠️ MEDIUM ARCH (7-9 dependencies):"
        grep "^MEDIUM" "$temp_file" | sort -t'|' -k3 -nr | while IFS='|' read -r severity icon total imports calls file problem_lines hot_functions; do
            printf "  %s %s: %d imports, %d calls\n" "$icon" "$file" "$imports" "$calls"
        done
        echo ""
    fi
    
    # Display LOW files (only if threshold is low)
    if [[ $low_files -gt 0 && $threshold -le 5 ]]; then
        echo "ℹ️ LOW ARCH (5-6 dependencies):"
        grep "^LOW" "$temp_file" | sort -t'|' -k3 -nr | while IFS='|' read -r severity icon total imports calls file problem_lines hot_functions; do
            printf "  %s %s: %d imports, %d calls\n" "$icon" "$file" "$imports" "$calls"
        done
        echo ""
    fi
    
    # Consolidated suggestions
    echo "🔧 SUGGESTED ACTIONS:"
    if [[ $critical_files -gt 0 ]]; then
        echo "  • Break critical files into smaller, focused modules"
        echo "  • Consider dependency injection for heavy arch"
    fi
    if [[ $high_files -gt 0 ]]; then
        echo "  • Review architectural boundaries and responsibilities"
        echo "  • Consolidate related imports where possible"
    fi
    if [[ $((critical_files + high_files)) -gt 0 ]]; then
        echo "  • Focus refactoring efforts on files with specific line locations shown above"
    fi
    
    rm -f "$temp_file"
}




# Trace function - tree-sitter + ripgrep symbol analysis
trace2() {
    local SYMBOL_NAME="${1:-}"
    local FILE_PATH="${2:-}"
    local LINE_NUMBER="${3:-}"
    local QUERIES_DIR="$SCRIPT_DIR/queries"

    # Usage function
    trace_usage() {
        echo "Usage: m trace <symbol_name> <file_path> [line_number]"
        echo "Example: m trace Database ./src/models.py 45"
        return 1
    }

    # Validate arguments
    [[ -z "$SYMBOL_NAME" || -z "$FILE_PATH" ]] && trace_usage
    [[ ! -f "$FILE_PATH" ]] && { echo "Error: File not found: $FILE_PATH"; return 1; }

    # Detect language from file extension
    detect_language() {
        case "${FILE_PATH##*.}" in
            py) echo "python" ;;
            js|jsx) echo "javascript" ;;
            ts|tsx) echo "typescript" ;;
            *) echo "unknown" ;;
        esac
    }

    local LANGUAGE=$(detect_language)

    # Tree-sitter symbol analysis
    analyze_symbol_definition() {
        local query_file="$QUERIES_DIR/$LANGUAGE-functions.scm"
        
        if [[ ! -f "$query_file" ]]; then
            echo "Warning: No query file for $LANGUAGE, using basic parsing"
            return 1
        fi
        
        echo "📖 DEFINED AT: $FILE_PATH"
        
        # Query tree-sitter for symbol definition
        local ts_output=$(tree-sitter query "$query_file" "$FILE_PATH" 2>/dev/null)
        if echo "$ts_output" | grep -q "text: \`$SYMBOL_NAME\`"; then
            echo "✅ Found symbol definition via tree-sitter"
            
            # Extract definition details
            local def_line=$(echo "$ts_output" | grep "function\.name.*text: \`$SYMBOL_NAME\`" | head -1)
            if [[ -n "$def_line" ]]; then
                if [[ "$def_line" =~ start:\ \(([0-9]+),\ ([0-9]+)\) ]]; then
                    local line_num=$((${BASH_REMATCH[1]} + 1))  # tree-sitter is 0-indexed
                    local col_num=$((${BASH_REMATCH[2]} + 1))
                    
                    echo "  📍 Function definition at line $line_num, column $col_num"
                    
                    # Get full function signature with context
                    local start_context=$((line_num - 2))
                    local end_context=$((line_num + 5))
                    [[ $start_context -lt 1 ]] && start_context=1
                    
                    echo "  📜 Full signature with context:"
                    sed -n "${start_context},${end_context}p" "$FILE_PATH" | nl -v$start_context | while read num content; do
                        if [[ $num -eq $line_num ]]; then
                            echo "  → $num: $content"  # Highlight the definition line
                        else
                            echo "    $num: $content"
                        fi
                    done
                fi
            fi
        else
            echo "⚠️  Symbol not found in tree-sitter analysis, falling back to basic parsing"
        fi
    }

    # Enhanced tree-sitter analysis functions
    analyze_internal_calls() {
        echo "🔗 INTERNAL CALLS:"
        
        local query_file="$QUERIES_DIR/$LANGUAGE-functions.scm"
        if [[ -f "$query_file" ]]; then
            local ts_output=$(tree-sitter query "$query_file" "$FILE_PATH" 2>/dev/null)
            local internal_calls=$(echo "$ts_output" | grep -E "internal_call.*text: \`.*\`")
            
            if [[ -n "$internal_calls" ]]; then
                echo "$internal_calls" | while read line; do
                    if [[ "$line" =~ text:.*\`([^\`]+)\` ]]; then
                        local call_name="${BASH_REMATCH[1]}"
                        echo "  🔄 Calls: $call_name"
                    fi
                done
            else
                echo "  No internal calls found"
            fi
        fi
    }

    analyze_class_relationships() {
        echo "🏗️ CLASS RELATIONSHIPS:"
        
        local class_query="$QUERIES_DIR/$LANGUAGE-classes.scm"
        if [[ -f "$class_query" ]]; then
            local ts_output=$(tree-sitter query "$class_query" "$FILE_PATH" 2>/dev/null)
            local class_info=$(echo "$ts_output" | grep -E "(class_method_rel|method_to_method).*text: \`.*\`")
            
            if [[ -n "$class_info" ]]; then
                echo "$class_info" | while read line; do
                    if [[ "$line" =~ text:.*\`([^\`]+)\` ]]; then
                        local element="${BASH_REMATCH[1]}"
                        if [[ "$line" =~ class_method_rel ]]; then
                            echo "  🏛️  Class method: $element"
                        elif [[ "$line" =~ method_to_method ]]; then
                            echo "  🔗 Method calls: $element"
                        fi
                    fi
                done
            else
                echo "  No class relationships found"
            fi
        fi
    }

    analyze_variable_usage() {
        echo "🔄 VARIABLE USAGE:"
        
        local var_query="$QUERIES_DIR/$LANGUAGE-variables.scm"
        if [[ -f "$var_query" ]]; then
            tree-sitter query --query-path "$var_query" "$FILE_PATH" 2>/dev/null | \
            grep -E "(variable_usage|attribute_access|param_usage)" | grep "$SYMBOL_NAME" | head -5 || echo "  No variable usage found"
        fi
    }

    analyze_nested_functions() {
        echo "📦 NESTED FUNCTIONS:"
        
        local nested_query="$QUERIES_DIR/$LANGUAGE-nested.scm"
        if [[ -f "$nested_query" ]]; then
            tree-sitter query --query-path "$nested_query" "$FILE_PATH" 2>/dev/null | \
            grep -E "(nested_function|closure)" | grep "$SYMBOL_NAME" | head -5 || echo "  No nested functions found"
        fi
    }

    analyze_exceptions() {
        echo "🚨 EXCEPTION HANDLING:"
        
        local exception_query="$QUERIES_DIR/$LANGUAGE-exceptions.scm"
        if [[ -f "$exception_query" ]]; then
            tree-sitter query --query-path "$exception_query" "$FILE_PATH" 2>/dev/null | \
            grep -E "(raise|except|try)" | grep -i "$SYMBOL_NAME" | head -5 || echo "  No exception handling found"
        fi
    }

    # Extract signature from file
    extract_signature() {
        echo "📋 SIGNATURE:"
        
        # Get line number from tree-sitter if not provided
        local symbol_line_num="$LINE_NUMBER"
        if [[ -z "$symbol_line_num" ]]; then
            local ts_output=$(tree-sitter query "$QUERIES_DIR/$LANGUAGE-functions.scm" "$FILE_PATH" 2>/dev/null)
            local def_line=$(echo "$ts_output" | grep "function\.name.*text: \`$SYMBOL_NAME\`" | head -1)
            if [[ "$def_line" =~ start:\ \(([0-9]+),\ ([0-9]+)\) ]]; then
                symbol_line_num=$((${BASH_REMATCH[1]} + 1))  # tree-sitter is 0-indexed
            fi
        fi
        
        if [[ -n "$symbol_line_num" ]]; then
            case "$LANGUAGE" in
                python)
                    # Extract multi-line function signature
                    local sig_start=$symbol_line_num
                    local sig_end=$symbol_line_num
                    
                    # Find the end of the signature (look for the closing parenthesis + colon)
                    local temp_line=$sig_start
                    while [[ $temp_line -le $((sig_start + 10)) ]]; do
                        local line_content=$(sed -n "${temp_line}p" "$FILE_PATH")
                        if [[ "$line_content" =~ .*\).*: ]]; then
                            sig_end=$temp_line
                            break
                        fi
                        temp_line=$((temp_line + 1))
                    done
                    
                    # Extract and format the complete signature
                    local full_signature=$(sed -n "${sig_start},${sig_end}p" "$FILE_PATH" | tr '\n' ' ' | sed 's/  */ /g')
                    echo "  $full_signature"
                    
                    # Parse parameters individually
                    if [[ "$full_signature" =~ \((.*)\) ]]; then
                        local params="${BASH_REMATCH[1]}"
                        if [[ -n "$params" && "$params" != " " ]]; then
                            echo "  📊 Parameters breakdown:"
                            # Split parameters by comma (basic split - doesn't handle complex nested structures)
                            echo "$params" | sed 's/,/\n/g' | while read -r param; do
                                param=$(echo "$param" | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
                                if [[ -n "$param" ]]; then
                                    if [[ "$param" =~ ^([^:=]+):([^=]+)(=(.*))?$ ]]; then
                                        local param_name="${BASH_REMATCH[1]// /}"
                                        local param_type="${BASH_REMATCH[2]// /}"
                                        local default_value="${BASH_REMATCH[4]}"
                                        
                                        echo -n "    • $param_name: $param_type"
                                        if [[ -n "$default_value" ]]; then
                                            echo " = $default_value"
                                        else
                                            echo ""
                                        fi
                                    elif [[ "$param" =~ ^([^=]+)=(.*)$ ]]; then
                                        local param_name="${BASH_REMATCH[1]// /}"
                                        local default_value="${BASH_REMATCH[2]}"
                                        echo "    • $param_name = $default_value"
                                    else
                                        echo "    • $param"
                                    fi
                                fi
                            done
                        else
                            echo "  📊 Parameters: None"
                        fi
                    fi
                    ;;
                *)
                    # Fallback for other languages
                    sed -n "${symbol_line_num}p" "$FILE_PATH" | sed 's/^[[:space:]]*//'
                    ;;
            esac
        else
            echo "  ⚠️  Could not extract signature"
        fi
    }

    # Symbol metadata from tree-sitter
    extract_metadata() {
        echo "🏷️  SYMBOL METADATA:"
        
        # Get line number from tree-sitter if not provided
        local symbol_line_num="$LINE_NUMBER"
        if [[ -z "$symbol_line_num" ]]; then
            local ts_output=$(tree-sitter query "$QUERIES_DIR/$LANGUAGE-functions.scm" "$FILE_PATH" 2>/dev/null)
            local def_line=$(echo "$ts_output" | grep "function\.name.*text: \`$SYMBOL_NAME\`" | head -1)
            if [[ "$def_line" =~ start:\ \(([0-9]+),\ ([0-9]+)\) ]]; then
                symbol_line_num=$((${BASH_REMATCH[1]} + 1))  # tree-sitter is 0-indexed
            fi
        fi
        
        if [[ -n "$symbol_line_num" ]]; then
            case "$LANGUAGE" in
                python)
                    echo "  📍 Location: Line $symbol_line_num"
                    
                    # Check for decorators (look up to 10 lines above)
                    local start_line=$((symbol_line_num - 10))
                    [[ $start_line -lt 1 ]] && start_line=1
                    local decorators=$(sed -n "${start_line},$((symbol_line_num-1))p" "$FILE_PATH" | rg "^\s*@\w+.*$" | tail -5)
                    
                    if [[ -n "$decorators" ]]; then
                        echo "  🎯 Decorators found:"
                        echo "$decorators" | while read decorator; do
                            echo "    $decorator"
                        done
                    else
                        echo "  🎯 Decorators: None"
                    fi
                    
                    # Look for docstring (next non-empty line after function def)
                    local docstring_line=$((symbol_line_num + 1))
                    local docstring=$(sed -n "${docstring_line},$((docstring_line + 5))p" "$FILE_PATH" | grep -E '^\s*""".*"""$|^\s*""".*' | head -1)
                    
                    if [[ -n "$docstring" ]]; then
                        echo "  📝 Docstring: ${docstring//\"/\\\"}"
                    else
                        echo "  📝 Docstring: None"
                    fi
                    
                    # Extract function signature details
                    local sig_line=$(sed -n "${symbol_line_num}p" "$FILE_PATH")
                    if [[ "$sig_line" =~ ^[[:space:]]*def[[:space:]]+$SYMBOL_NAME[[:space:]]*\((.*)\)[[:space:]]*(->[[:space:]]*[^:]+)?:[[:space:]]*$ ]]; then
                        local params="${BASH_REMATCH[1]}"
                        local return_type="${BASH_REMATCH[2]}"
                        
                        echo "  📊 Parameters: $params"
                        if [[ -n "$return_type" ]]; then
                            echo "  📤 Return type: $return_type"
                        else
                            echo "  📤 Return type: Not annotated"
                        fi
                        
                        # Check for async
                        if [[ "$sig_line" =~ ^[[:space:]]*async[[:space:]]+def ]]; then
                            echo "  ⚡ Function type: Async"
                        else
                            echo "  ⚡ Function type: Sync"
                        fi
                    fi
                    
                    # Check if it's a method (inside a class)
                    local class_context=$(sed -n "1,${symbol_line_num}p" "$FILE_PATH" | tac | rg "^class\s+\w+" | head -1)
                    if [[ -n "$class_context" ]]; then
                        local class_name=$(echo "$class_context" | sed 's/^class\s\+\([^(:]*\).*/\1/')
                        echo "  🏛️  Class context: $class_name"
                        
                        # Check method type
                        if [[ "$sig_line" =~ \(self, ]]; then
                            echo "  🔧 Method type: Instance method"
                        elif [[ "$sig_line" =~ \(cls, ]]; then
                            echo "  🔧 Method type: Class method"
                        else
                            echo "  🔧 Method type: Static method"
                        fi
                    else
                        echo "  🏛️  Scope: Module level"
                    fi
                    ;;
            esac
        else
            echo "  ⚠️  Could not determine symbol location"
        fi
    }

    # Cross-file references with ripgrep
    find_references() {
        echo "📞 CALLED BY:"
        
        # Find all references across the codebase
        local file_dir=$(dirname "$FILE_PATH")
        
        # Search in current directory and subdirectories
        rg "$SYMBOL_NAME" "$file_dir" \
            --type py \
            --line-number \
            --max-count=10 \
            --context=0 \
            --no-heading \
            --with-filename \
            | grep -v "^$FILE_PATH:" \
            | head -10 || echo "  No external references found"
    }

    # Import analysis
    find_imports() {
        echo "📦 IMPORTED BY:"
        
        local file_dir=$(dirname "$FILE_PATH")
        local module_name=$(basename "$FILE_PATH" .py)
        
        # Find files that import this module/symbol
        rg "(from.*$module_name|import.*$module_name|import.*$SYMBOL_NAME)" "$file_dir" \
            --type py \
            --line-number \
            --max-count=5 \
            | head -5 || echo "  No imports found"
    }

    # Dependencies analysis
    find_dependencies() {
        echo "📦 DEPENDENCIES:"
        
        # Find what this symbol imports/uses
        case "$LANGUAGE" in
            python)
                # Look for imports at the top of the file
                rg "^(import|from)" "$FILE_PATH" --line-number | head -10
                ;;
        esac
    }

    # Main execution
    echo "=== 🔍 TRACE ANALYSIS: $SYMBOL_NAME ==="
    echo ""
    
    analyze_symbol_definition
    echo ""
    
    extract_signature  
    echo ""
    
    extract_metadata
    echo ""
    
    # Enhanced analysis sections
    analyze_internal_calls
    echo ""
    
    analyze_class_relationships
    echo ""
    
    analyze_variable_usage
    echo ""
    
    analyze_nested_functions
    echo ""
    
    analyze_exceptions
    echo ""
    
    find_references
    echo ""
    
    find_imports
    echo ""
    
    find_dependencies
    echo ""
    
    echo "=== Analysis Complete ==="
}

minit() {
    mkdir -p .m/rules

    # Create separate rule files (ast-grep prefers one rule per file)
    cat > .m/rules/god-function.yml << 'EOF'
id: god-function
message: "Large function detected - consider breaking into smaller functions"
severity: warning
language: python
rule:
  pattern: |
    def $NAME($$$):
      $$$
EOF

    cat > .m/rules/unused-import.yml << 'EOF'
id: unused-import
message: "Potential unused import - verify usage"
severity: info
language: python
rule:
  pattern: "import $MODULE"
EOF

    cat > .m/rules/complexity.yml << 'EOF'
id: complexity
message: "Complex conditional detected"
severity: info
language: python
rule:
  pattern: |
    if $COND1 and $COND2 and $COND3:
      $$$
EOF

    # Add violation detection rules
    cat > .m/rules/violations.yml << 'EOF'
id: direct-db-access
message: "Direct database access detected - consider using repository pattern"
severity: warning
language: python
rule:
  pattern: |
    $VAR.execute($$$)
EOF

    cat > .m/rules/god-class.yml << 'EOF'
id: god-class
message: "Large class detected - consider breaking into smaller classes"
severity: warning
language: python
rule:
  pattern: |
    class $NAME:
      $$$
EOF

    cat > .m/rules/hardcoded-values.yml << 'EOF'
id: hardcoded-values
message: "Hardcoded string/number detected - consider using configuration"
severity: info
language: python
rule:
  any:
    - pattern: 'print("$HARDCODED")'
    - pattern: '$VAR = "localhost"'
    - pattern: '$VAR = 3306'
EOF

    # Create sgconfig.yml for ast-grep scan
    cat > sgconfig.yml << 'EOF'
ruleDirs:
  - .m/rules
util: {}
EOF

    echo "Initialized ast-grep project with rules and config"
}
