#!/bin/bash
# Memory MCP replacement functions

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


