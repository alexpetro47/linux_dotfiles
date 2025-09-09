#!/bin/bash
# Memory MCP replacement functions

mfind() {
    local query="$1"
    local filter_query="${2:-$query}"
    
    echo "=== 🔍 SEMANTIC SEARCH: $query ==="
    
    # Multi-pattern semantic search with context grouping
    local patterns=""
    
    # Expand query into semantic variants
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

# This function is now replaced by enhanced relations above

# Refactor command removed - insufficient value over direct ast-grep usage

# Analyze command removed - unacceptable noise-to-signal ratio

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

find_all_references() {
    local query=$1
    local filter_query=${2:-"$query"}
    
    # Enhanced output with context and icons
    rg "$query" --type-add 'code:*.{py,js,ts,jsx,tsx,go,rs,c,cpp,h,hpp}' -t code -n -C 1 | \
    sed -n '/^[^:]*:[0-9]*:/p' | \
    while IFS=':' read -r file line content; do
        if echo "$content" | grep -qE '(def |class |function |const |let |var )'; then
            printf "📍 %s:%s\n   %s\n" "$file" "$line" "$(echo "$content" | cut -c1-80)$([ ${#content} -gt 80 ] && echo '...')"
        else
            clean_content=$(echo "$content" | sed 's/^[[:space:]]*//')
            printf "🔗 %s:%s\n   %s\n" "$file" "$line" "$(echo "$clean_content" | cut -c1-60)$([ ${#clean_content} -gt 60 ] && echo '...')"
        fi
    done | \
    fzf --filter="$filter_query" --no-sort
}



# 🥉 PRIORITY 3: Coupling Analysis
coupling() {
    local threshold="${1:-5}"
    local filter_query="${2:-""}"
    
    echo "=== 🔗 COUPLING ANALYSIS (threshold: $threshold) ==="
    
    # Collect all results first
    local temp_file="/tmp/coupling_results_$$"
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
        echo "🔴 CRITICAL COUPLING (15+ dependencies):"
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
        echo "🚨 HIGH COUPLING (10-14 dependencies):"
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
        echo "⚠️ MEDIUM COUPLING (7-9 dependencies):"
        grep "^MEDIUM" "$temp_file" | sort -t'|' -k3 -nr | while IFS='|' read -r severity icon total imports calls file problem_lines hot_functions; do
            printf "  %s %s: %d imports, %d calls\n" "$icon" "$file" "$imports" "$calls"
        done
        echo ""
    fi
    
    # Display LOW files (only if threshold is low)
    if [[ $low_files -gt 0 && $threshold -le 5 ]]; then
        echo "ℹ️ LOW COUPLING (5-6 dependencies):"
        grep "^LOW" "$temp_file" | sort -t'|' -k3 -nr | while IFS='|' read -r severity icon total imports calls file problem_lines hot_functions; do
            printf "  %s %s: %d imports, %d calls\n" "$icon" "$file" "$imports" "$calls"
        done
        echo ""
    fi
    
    # Consolidated suggestions
    echo "🔧 SUGGESTED ACTIONS:"
    if [[ $critical_files -gt 0 ]]; then
        echo "  • Break critical files into smaller, focused modules"
        echo "  • Consider dependency injection for heavy coupling"
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



# 🔍 REFERENCE ANALYSIS TOOLS
mrefs() {
    local symbol="${1:-}"
    local depth="${2:-2}"
    
    if [[ -z "$symbol" ]]; then
        echo "Usage: m refs <symbol> [depth]"
        echo "Example: m refs UserManager 2"
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
