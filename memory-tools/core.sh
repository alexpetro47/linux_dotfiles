#!/bin/bash
# Memory MCP replacement functions

# Find2 MVP - Comprehensive code discovery tool
find2() {
    local query="$1"
    
    if [[ -z "$query" ]]; then
        echo "Usage: find2 <query>"
        echo "Example: find2 database"
        return 1
    fi
    
    echo "=== 🔍 COMPREHENSIVE DISCOVERY: $query ==="
    echo ""
    
    # Create temporary files for parallel execution
    local tmp_dir="/tmp/find2_$$"
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

# Symbol search with ctags - extracts symbols and maps to categories
search_symbols() {
    local query="$1"
    
    # Generate ctags if needed
    if [[ ! -f ".ast-grep/tags" ]] || [[ $(find . -name "*.py" -o -name "*.sh" -newer ".ast-grep/tags" | wc -l) -gt 0 ]]; then
        mkdir -p .ast-grep
        ctags -f .ast-grep/tags -R --languages=Sh,Python,JavaScript,TypeScript --exclude=".venv" --exclude="node_modules" . 2>/dev/null
    fi
    
    # Search ctags for symbols matching query
    if [[ -f ".ast-grep/tags" ]]; then
        grep -v "^!" .ast-grep/tags | grep -i "$query" | while IFS=$'\t' read -r symbol file pattern kind_info; do
            # Extract kind from kind_info (format: ;"<tab>kind)
            local kind=$(echo "$kind_info" | sed 's/.*"//' | cut -c1)
            
            # Try to extract line number from pattern or use grep to find it
            local line_num=$(rg -n "^${symbol}\\s*\\(" "$file" 2>/dev/null | head -1 | cut -d: -f1)
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
            
            # Get the actual line content for signature
            if [[ -f "$file" ]]; then
                local signature=$(sed -n "${line_num}p" "$file" 2>/dev/null | sed 's/^[[:space:]]*//' | cut -c1-80)
                [[ ${#signature} -gt 77 ]] && signature="${signature:0:77}..."
                echo "SYMBOL|$category|$file|$line_num|$symbol - $signature"
            fi
        done
    fi
    
    # Additional ripgrep-based variable detection
    rg "^[[:space:]]*(local|readonly|declare|export)?[[:space:]]*$query[a-zA-Z0-9_]*[[:space:]]*=" \
        --type-add 'code:*.{py,js,ts,jsx,tsx,sh,bash,zsh,go,rs,c,cpp,h,hpp,java,rb,php}' \
        -t code \
        --line-number \
        --no-heading \
        --max-count=5 \
        . 2>/dev/null | \
    while IFS=':' read -r file line content; do
        # Clean up content for display
        local clean_content=$(echo "$content" | sed 's/^[[:space:]]*//' | cut -c1-80)
        [[ ${#content} -gt 77 ]] && clean_content="${clean_content:0:77}..."
        
        # Extract variable name from the line
        local var_name=$(echo "$content" | sed 's/^[[:space:]]*\(local\|readonly\|declare\|export\)*[[:space:]]*//' | sed 's/[[:space:]]*=.*//')
        
        echo "SYMBOL|variable|$file|$line|$var_name - $clean_content"
    done
    
    # Search for const/let/var declarations (JavaScript/TypeScript)
    rg "^[[:space:]]*(const|let|var)[[:space:]]+.*$query" \
        --type js --type ts \
        --line-number \
        --no-heading \
        --max-count=3 \
        . 2>/dev/null | \
    while IFS=':' read -r file line content; do
        local clean_content=$(echo "$content" | sed 's/^[[:space:]]*//' | cut -c1-80)
        [[ ${#content} -gt 77 ]] && clean_content="${clean_content:0:77}..."
        
        local var_name=$(echo "$content" | sed 's/^[[:space:]]*\(const\|let\|var\)[[:space:]]*//' | sed 's/[[:space:]]*=.*//' | sed 's/[[:space:]]*:.*//')
        
        echo "SYMBOL|variable|$file|$line|$var_name - $clean_content"
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
        --max-count=3 \
        . 2>/dev/null | \
    while IFS=':' read -r file line content; do
        # Clean up content for display
        local clean_content=$(echo "$content" | sed 's/^[[:space:]]*//' | cut -c1-80)
        [[ ${#content} -gt 77 ]] && clean_content="${clean_content:0:77}..."
        
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
        --max-results 20 \
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
        printf "%-8s %s:%-4s %s\n" "$category" "$file" "$line" "$signature"
    done | head -15
    
    echo ""
    
    # Display content
    echo "📝 CONTENT"  
    grep "^CONTENT" "$dedup_results" | \
    while IFS='|' read -r source category file line content; do
        printf "%s:%-4s %s\n" "$file" "$line" "$content"
    done | head -10
    
    echo ""
    
    # Display structure
    echo "🏗️ STRUCTURE"
    grep "^STRUCTURE\|^SEMANTIC.*file" "$dedup_results" | \
    while IFS='|' read -r source category file line path; do
        echo "$path"
    done | sort -u | head -10
}



mfind() {
    local query="$1"
    local filter_query="${2:-$query}"
    
    echo "=== 🔍 CODE SEARCH: $query ==="
    
    # Multi-pattern code search with context grouping
    local patterns=""
    
    # Expand query into pattern variants
    case "$query" in
        *"error"*|*"exception"*)
            patterns="try|except|catch|error|exception|raise|throw"
            ;;
        *"database"*|*"db"*)
            patterns="database|connect|query|sql|cursor|transaction|commit|rollback"
            ;;
        *"auth"*|*"login"*)
            patterns="auth|login|authenticate|authorize|permission|token|session"
            ;;
        *"test"*)
            patterns="test|assert|mock|expect|should|describe|it\("
            ;;
        *"config"*|*"setting"*)
            patterns="config|setting|option|parameter|env|environment"
            ;;
        *)
            # Default: use the query as-is plus common related patterns
            patterns="$query"
            ;;
    esac
    
    # Search with enhanced context and grouping
    rg "$patterns" --type-add 'code:*.{py,js,ts,jsx,tsx,go,rs,c,cpp,h,hpp}' -t code --smart-case -A 2 -B 1 -n | \
    sed -n '/^[^:]*:[0-9]*:/p' | \
    while IFS=':' read -r file line content; do
        # Add relevance context
        local relevance="🔗"
        if echo "$content" | grep -qE '(def |class |function |const |let |var )'; then
            relevance="📍"
        elif echo "$content" | grep -qE '(import |from |include |require)'; then
            relevance="📦"
        fi
        
        printf "%s %s:%s\n   %s\n" "$relevance" "$file" "$line" "$(echo "$content" | sed 's/^[[:space:]]*//' | cut -c1-70)$([ ${#content} -gt 70 ] && echo '...')"
    done | fzf --filter="$filter_query" --no-sort
}



mtrace() {
    local symbol="${1:-}"
    local depth="${2:-2}"
    
    if [[ -z "$symbol" ]]; then
        echo "Usage: m trace <symbol> [depth]"
        echo "Example: m trace UserManager 2"
        return 1
    fi
            
            echo "=== 🔍 COMPREHENSIVE ANALYSIS: $symbol ==="
            
            # Find definition first
            local definition=$(rg "^\s*(def|class)\s+$symbol\b" --type py -n | head -1)
            if [[ -n "$definition" ]]; then
                local def_file=$(echo "$definition" | cut -d: -f1)
                local def_line=$(echo "$definition" | cut -d: -f2)
                local def_type=$(echo "$definition" | grep -o "^\s*\(def\|class\)" | sed 's/^\s*//')
                printf "📍 %s %s defined in %s:%s\n\n" "$def_type" "$symbol" "$def_file" "$def_line"
            fi
            
            # DEPENDENCIES (what this symbol uses)
            echo "=== 📦 DEPENDENCIES (what $symbol uses) ==="
            if [[ -n "$definition" ]]; then
                local def_file=$(echo "$definition" | cut -d: -f1)
                local def_line=$(echo "$definition" | cut -d: -f2)
                local next_def=$(rg -n "^\s*(def|class)\s+" "$def_file" | awk -F: -v start="$def_line" '$1 > start {print $1; exit}')
                local end_line=${next_def:-$(wc -l < "$def_file")}
                
                # Extract function/class body and find its dependencies
                sed -n "${def_line},${end_line}p" "$def_file" | \
                rg '[a-zA-Z_][a-zA-Z0-9_]*\.[a-zA-Z_][a-zA-Z0-9_]*\(' -o | \
                sed 's/\..*$//' | sort -u | head -10 | \
                while read dep; do
                    printf "├── 🔗 uses %s\n" "$dep"
                done
                
                # Also check imports within the function
                sed -n "${def_line},${end_line}p" "$def_file" | \
                rg '(from .* import|import )([a-zA-Z_][a-zA-Z0-9_.]*)' -o | \
                while read import_line; do
                    printf "├── 📦 imports %s\n" "$import_line"
                done
            fi
            
            echo ""
            # REVERSE DEPENDENCIES (what uses this symbol)
            echo "=== ⬅️ REVERSE DEPENDENCIES (what uses $symbol) ==="
            
            # IMPORTS
            echo "📦 IMPORTED BY:"
            (rg "from .* import.*$symbol" --type py -n; rg "import.*$symbol" --type py -n | grep -v "from") | \
            while IFS=':' read -r file line content; do
                local risk="LOW"
                local risk_icon="🟢"
                
                if echo "$content" | grep -q "from.*\..*\..*import"; then
                    risk="MEDIUM"
                    risk_icon="🟡"
                fi
                if echo "$content" | grep -qE "(test|mock|debug)" && ! echo "$file" | grep -qE "(test|spec)"; then
                    risk="HIGH"
                    risk_icon="🔴"
                fi
                
                printf "%s 📦 %s:%s [%s] (%s)\n" "$risk_icon" "$file" "$line" "$risk" "$(echo "$content" | sed 's/^[[:space:]]*//' | cut -c1-50)$([ ${#content} -gt 50 ] && echo '...')"
            done
            
            echo ""
            echo "📞 CALLED BY:"
            rg "$symbol\(" --type py -n -C 1 | \
            sed -n '/^[^:]*:[0-9]*:/p' | \
            while IFS=':' read -r file line content; do
                local risk="LOW"
                local risk_icon="🟢"
                
                if echo "$content" | grep -qE "(try|except|catch|if.*and.*$symbol|while.*$symbol|for.*$symbol)"; then
                    risk="MEDIUM"
                    risk_icon="🟡"
                fi
                if echo "$content" | grep -qE "(except.*$symbol|raise.*$symbol|$symbol.*$symbol)"; then
                    risk="HIGH"
                    risk_icon="🔴"
                fi
                
                printf "%s 📞 %s:%s [%s] (%s)\n" "$risk_icon" "$file" "$line" "$risk" "$(echo "$content" | sed 's/^[[:space:]]*//' | cut -c1-45)$([ ${#content} -gt 45 ] && echo '...')"
            done
            
            echo ""
            echo "🏗️ INSTANTIATED BY:"
            rg "$symbol\(\)" --type py -n | \
            while IFS=':' read -r file line content; do
                local risk="LOW"
                local risk_icon="🟢"
                
                if echo "$content" | grep -qE "(for|while|global|^[[:space:]]*$symbol\(\))"; then
                    risk="MEDIUM"
                    risk_icon="🟡"
                fi
                if echo "$content" | grep -o "$symbol()" | wc -l | grep -q "[2-9]"; then
                    risk="HIGH"
                    risk_icon="🔴"
                fi
                
                printf "%s 🏗️ %s:%s [%s] (%s)\n" "$risk_icon" "$file" "$line" "$risk" "$(echo "$content" | sed 's/^[[:space:]]*//' | cut -c1-45)$([ ${#content} -gt 45 ] && echo '...')"
            done
            
            # TRANSITIVE IMPACT ANALYSIS
            if [[ $depth -ge 2 ]]; then
                echo ""
                echo "=== ⛓️ TRANSITIVE IMPACT (depth: $depth) ==="
                
                local temp_file="/tmp/transitive_deps_$$"
                local level1_files=$(rg "\b$symbol\b" --type py -l | head -10)
                
                if [[ -n "$level1_files" ]]; then
                    echo "$level1_files" | while read file; do
                        local funcs_with_symbol=$(rg -n "^\s*def\s+[a-zA-Z_][a-zA-Z0-9_]*\(" "$file" | \
                            while IFS=':' read -r line_num line_content; do
                                local func_name=$(echo "$line_content" | sed 's/.*def\s*\([a-zA-Z_][a-zA-Z0-9_]*\).*/\1/')
                                local func_end=$((line_num + 30))
                                local next_def=$(rg -n "^\s*(def|class)\s+" "$file" | awk -F: -v start="$line_num" '$1 > start {print $1; exit}')
                                if [[ -n "$next_def" ]]; then
                                    func_end=$((next_def - 1))
                                fi
                                
                                local func_body=$(sed -n "${line_num},${func_end}p" "$file")
                                if echo "$func_body" | grep -q "\b$symbol\b"; then
                                    echo "$func_name"
                                fi
                            done)
                        
                        if [[ -n "$funcs_with_symbol" ]]; then
                            echo "$funcs_with_symbol" | while read intermediate_func; do
                                rg "\b$intermediate_func\(" --type py -n | grep -v "def $intermediate_func" | head -3 | \
                                while IFS=':' read -r caller_file caller_line caller_content; do
                                    printf "└── ⛓️ %s:%s → %s() → %s (chain)\n" "$caller_file" "$caller_line" "$intermediate_func" "$symbol"
                                done
                            done
                        fi
                    done > "$temp_file"
                    
                    if [[ -s "$temp_file" ]]; then
                        cat "$temp_file"
                        local blast_radius=$(wc -l < "$temp_file")
                        echo ""
                        printf "📊 BLAST RADIUS: %d transitive dependencies found\n" "$blast_radius"
                    else
                        echo "     No transitive dependencies found"
                    fi
                    rm -f "$temp_file"
                fi
            fi
            
            # REFACTOR IMPACT SUMMARY
            echo ""
            echo "=== 🛠️ REFACTOR IMPACT SUMMARY ==="
            local files_affected=$(rg "\b$symbol\b" --type py -l | wc -l)
            local total_usages=$(rg "\b$symbol\b" --type py | wc -l)
            
            printf "📊 Files affected: %d\n" "$files_affected"
            printf "📊 Total usages: %d\n" "$total_usages"
            
            echo ""
            echo "=== 🔥 USAGE HOTSPOTS ==="
            rg "\b$symbol\b" --type py -c | sort -t: -k2 -nr | head -5 | \
            while IFS=':' read -r file count; do
                printf "🔥 %s (%d usages)\n" "$file" "$count"
            done
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




minit() {
    mkdir -p .ast-grep/rules

    # Create separate rule files (ast-grep prefers one rule per file)
    cat > .ast-grep/rules/god-function.yml << 'EOF'
id: god-function
message: "Large function detected - consider breaking into smaller functions"
severity: warning
language: python
rule:
  pattern: |
    def $NAME($$$):
      $$$
EOF

    cat > .ast-grep/rules/unused-import.yml << 'EOF'
id: unused-import
message: "Potential unused import - verify usage"
severity: info
language: python
rule:
  pattern: "import $MODULE"
EOF

    cat > .ast-grep/rules/complexity.yml << 'EOF'
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
    cat > .ast-grep/rules/violations.yml << 'EOF'
id: direct-db-access
message: "Direct database access detected - consider using repository pattern"
severity: warning
language: python
rule:
  pattern: |
    $VAR.execute($$$)
EOF

    cat > .ast-grep/rules/god-class.yml << 'EOF'
id: god-class
message: "Large class detected - consider breaking into smaller classes"
severity: warning
language: python
rule:
  pattern: |
    class $NAME:
      $$$
EOF

    cat > .ast-grep/rules/hardcoded-values.yml << 'EOF'
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
  - .ast-grep/rules
util: {}
EOF

    echo "Initialized ast-grep project with rules and config"
}
