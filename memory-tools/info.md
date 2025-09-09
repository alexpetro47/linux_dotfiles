
# INFO




## CLI-ONLY TOOLKIT
- ast-grep (sg) - AST-based code search/rewrite tool
- fzf - Fuzzy finder for interactive selection
- ripgrep (rg) - Fast text search tool
- jq - JSON processor
* yq - yaml/xml parsing
- bat - Syntax-highlighted file viewer
- miller - Text/CSV data processing tool with SQL-like queries
- fd-find (fd) - Fast alternative to find with intuitive syntax
- sd (better "sed") - Intuitive find-and-replace with regex support
* universal-ctags (ctags) - pseudo lsp information for types, methods, etc
* git
* standard unix tools
  * xargs - 9/10 - Essential pipeline bridge
  * head/tail - 9/10 - Data sampling/log monitoring
  * sort - 8/10 - Pipeline data ordering
  * uniq - 8/10 - Deduplicate (with sort)
  * wc - 7/10 - Quick counts

* consider integating memory mcp functionality for semantic search 
  * global db? subdir-based search? 



### "M COUPLING"
*File-Level Architecture Assessment*
- Purpose: "Which files have structural problems?"
- Scope: Entire codebase health assessment
- Granularity: File-level metrics (imports + calls)
- Output: Problematic files grouped by severity
- Use Case: Discovery of architectural hotspots

```
=== 🔗 COUPLING ANALYSIS (threshold: 20) ===
📊 SUMMARY: 14 Critical, 0 High, 0 Medium, 0 Low
🔴 CRITICAL COUPLING (15+ dependencies):
  🔴 ./graph_store.py: 23 imports, 255 calls
     📍 Lines: 10,19,24
  🔴 ./mcp_server.py: 22 imports, 223 calls
     📍 Lines: 34,35,50
  🔴 ./tests/test_graph_store.py: 13 imports, 160 calls
     📍 Lines: 15,23,29
  🔴 ./code_parser.py: 16 imports, 156 calls
     📍 Lines: 19,24,29
  🔴 ./database.py: 8 imports, 126 calls
     📍 Lines: 14,19,25
  🔴 ./parse_helpers.py: 10 imports, 89 calls
     📍 Lines: 15,40,58
  🔴 ./pattern_detector.py: 5 imports, 82 calls
     📍 Lines: 7,29,30
  🔴 ./tests/test_mcp_integration.py: 20 imports, 66 calls
     📍 Lines: 24,28,33
  🔴 ./tests/test_cross_file_dependencies.py: 5 imports, 75 calls
     📍 Lines: 16,23,28
  🔴 ./tests/test_architectural_analysis.py: 5 imports, 73 calls
     📍 Lines: 16,23,50
  🔴 ./doc_parser.py: 8 imports, 69 calls
     📍 Lines: 28,29,33
  🔴 ./tests/test_performance_benchmarks.py: 17 imports, 56 calls
     📍 Lines: 20,21,26
  🔴 ./tests/test_relationship_extraction.py: 21 imports, 51 calls
     📍 Lines: 25,26,32
  🔴 ./code_embeddings.py: 3 imports, 17 calls
     📍 Lines: 7,20,22
🔧 SUGGESTED ACTIONS:
  • Break critical files into smaller, focused modules
  • Consider dependency injection for heavy coupling
  • Focus refactoring efforts on files with specific line locations shown above
```



### "M REFS"
*Symbol-Level Impact Analysis*
  - Purpose: "What happens if I change this specific symbol?"
  - Scope: Deep relationship tracing for individual symbols
  - Granularity: Function/class/variable relationships
  - Output: Bidirectional dependencies + transitive impact
  - Use Case: Change safety assessment before refactoring

```
=== 🔍 COMPREHENSIVE ANALYSIS: Database ===
📍  Database defined in database.py:9
=== 📦 DEPENDENCIES (what Database uses) ===
=== ⬅️  REVERSE DEPENDENCIES (what uses Database) ===
📦 IMPORTED BY:
🟢 📦 doc_parser.py:11 [LOW] (from database import Database)
🟢 📦 mcp_server.py:19 [LOW] (from database import Database)
🟢 📦 tests/test_performance_benchmarks.py:9 [LOW] (from database import Database)
🟢 📦 vector_store.py:7 [LOW] (from database import Database)
🟢 📦 parse_helpers.py:9 [LOW] (from database import Database)
🟢 📦 tests/test_mcp_integration.py:12 [LOW] (from database import Database)
📞 CALLED BY:
🟢 📞 mcp_server.py:165 [LOW] (db = Database(source_path)...)
🟢 📞 mcp_server.py:254 [LOW] (db = Database(source_path)...)
🟢 📞 parse_helpers.py:31 [LOW] (db = Database(source_path))
🟢 📞 parse_helpers.py:165 [LOW] (db = Database(source_path))
🟢 📞 parse_helpers.py:274 [LOW] (db = Database(source_path))
🟢 📞 tests/test_performance_benchmarks.py:140 [LOW] (db = Database(self.temp_dir))
🟢 📞 tests/test_performance_benchmarks.py:179 [LOW] (db = Database(self.temp_dir))
🟢 📞 tests/test_performance_benchmarks.py:239 [LOW] (db = Database(self.temp_dir))
🟢 📞 tests/test_performance_benchmarks.py:295 [LOW] (db = Database(self.temp_dir))
🟢 📞 tests/test_performance_benchmarks.py:350 [LOW] (db = Database(large_temp_dir))
🟢 📞 tests/test_mcp_integration.py:244 [LOW] (db = Database(self.temp_dir))
🟢 📞 tests/test_mcp_integration.py:286 [LOW] (db = Database(self.temp_dir))
🏗️  INSTANTIATED BY:
=== ⛓️  TRANSITIVE IMPACT (depth: 2) ===
     No transitive dependencies found
=== 🛠️  REFACTOR IMPACT SUMMARY ===
📊 Files affected: 8
📊 Total usages: 31
=== 🔥 USAGE HOTSPOTS ===
🔥 parse_helpers.py (10 usages)
🔥 tests/test_performance_benchmarks.py (8 usages)
🔥 mcp_server.py (4 usages)
🔥 tests/test_mcp_integration.py (3 usages)
🔥 vector_store.py (2 usages)
```


### "M FIND"

* add vector storage from memory mcp project?



Text Search Tools

- ripgrep (rg) - Fast regex/text search (already integrated)
- grep -E - Extended regex patterns
- ack - Programmer-focused search
- ag (Silver Searcher) - Fast text search with ignore patterns

File Discovery Tools

- find - File name/path/metadata search
- fd - Modern, fast alternative to find
- locate/mlocate - Indexed file search
- which/whereis - Command/binary location

Code Analysis Tools

- ast-grep - AST-based structural search (partially integrated)
- semgrep - Semantic code search patterns
- ctags/universal-ctags - Symbol indexing and search
- cscope - Code browsing/cross-reference

Content Analysis

- fzf - Fuzzy finder (already integrated for filtering)
- peco/percol - Interactive filtering
- jq - JSON querying (for structured code analysis)
- yq - YAML/XML querying

Git Integration

- git grep - Repository-aware search
- git log --grep - Commit message search
- git log -S - Code history search (pickaxe)

Advanced Search Techniques

- Fuzzy matching - Approximate string matching
- Semantic embeddings - AI-powered similarity search
- N-gram analysis - Pattern frequency analysis
- Levenshtein distance - Edit distance matching

Best Non-Redundant Integration Set

m find "pattern"                    # ripgrep + semantic expansion
m find --files "*.py"               # fd for file discovery
m find --fuzzy "databse"            # fzf fuzzy matching
m find --ast "class with methods"   # ast-grep structural search
m find --git "removed function"     # git log -S code archaeology
m find --symbols "Manager"          # ctags symbol search
m find --regex "def \w+_handler"    # Enhanced regex with context

Result: Single command consolidating 15+ CLI tools while avoiding overlap with refs (relationship analysis) and
coupling (architectural assessment).







  Consolidation Analysis

  - Content Tools: rg + grep + ack + ag → Single Content Backend
  - Structure Tools: ast-grep + semgrep + ctags → Single Structure Backend
  - File Tools: find + fd + locate + git → Single File Backend
  - Interactive Tools: fzf + peco + fuzzy → Fuzzy Layer (applies to all)

  Unified Command Structure

  m find "query" [--fuzzy] [--in=scope] [--type=match_type]

  # Examples:
  m find "database"                    # Auto-detect: content search
  m find "UserManager" --type=symbol   # Structure backend
  m find "test_*.py" --type=file       # File backend
  m find "databse" --fuzzy             # Typo tolerance
  m find "auth" --in=functions         # Scope filtering

  Key Arguments (Semantic, Not Tool-Based)

  - --type: content|symbol|file|history (backend selection)
  - --fuzzy: Enable approximate matching
  - --in: functions|classes|tests|files (scope filtering)
  - --match: exact|regex|semantic (matching strategy)

  Flexible Fuzzy Search Capabilities

  1. Multi-Level Fuzzy: "databse connction" → fuzzy filename + fuzzy content
  2. Semantic Fuzzy: "auth --fuzzy" matches login, permission, authenticate
  3. Pattern Fuzzy: "get*usr --fuzzy" → get_user_profile, getUserData
  4. Contextual Fuzzy: Search within fuzzy-matched files/functions
  5. Typo + Concept: "fucntion handlr" → function handler + semantic expansion



  Replace Interactive Components

  - fzf --filter="pattern" → --limit=k --rank-by=relevance
  - peco/percol → --top=k --sort-by=score
  - Interactive selection → --best-match --max-results=k

  Non-Interactive Command Structure

  m find "query" --limit=5 --rank-by=relevance
  m find "database" --top=3 --sort-by=frequency
  m find "UserManager" --best-match --threshold=0.8
  m find "auth" --max-results=10 --min-score=0.5

  Ranking/Filtering Options

  - --limit=k: Return top k results only
  - --threshold=n: Minimum relevance score (0.0-1.0)
  - --rank-by: relevance|frequency|recency|alphabetical
  - --sort-by: score|location|file|type
  - --best-match: Return single highest-scoring result
  - --dedup: Remove duplicate/similar results

  AI Agent-Friendly Output

  # Structured output for parsing
  m find "database" --format=json --limit=5
  m find "auth" --format=tsv --rank-by=relevance
  m find "error" --format=lines --best-match

  Default Behavior

  # No flags = top 10 results, relevance-ranked, deduplicated
  m find "pattern"

  # Equivalent to:
  m find "pattern" --limit=10 --rank-by=relevance --dedup






● Universal-ctags/cscope Value Analysis

  Significant Value for find

  - Language-aware symbol search vs ripgrep's text matching
  - No false positives from comments/strings containing symbol names
  - Hierarchical understanding: knows UserManager.login() vs AdminManager.login()
  - Partial completion: m find "User" --type=symbol finds UserManager, UserService
  - 40+ language support with consistent interface

  Moderate Value for refs

  - More precise call graphs than regex-based relationship detection
  - Accurate symbol disambiguation (multiple login functions)
  - Cross-reference accuracy without regex false positives

  Practical Integration

  # Enhanced find with symbol awareness
  m find "Manager" --type=symbol     # ctags: only actual symbols, not comments
  m find "get_user" --fuzzy          # ctags: fuzzy symbol matching

  # More accurate refs analysis
  m refs UserManager --precise       # ctags: accurate call graph vs regex approximation

  Trade-off Considerations

  - Setup cost: Requires index generation/maintenance
  - Fallback strategy: Use ripgrep when ctags unavailable
  - Real-time vs indexed: ripgrep works immediately, ctags needs preparation

  Recommendation

  YES - High value addition:
  - For find: ctags eliminates false positives and provides language-aware symbol search
  - For refs: Optional --precise mode using ctags for complex codebases
  - Implementation: ctags-first with ripgrep fallback ensures reliability

  Result: ctags/cscope transform text-based search into code-aware analysis, significantly improving accuracy for
   symbol operations.







  Enhanced Output with AST-grep additions:

  Current:
  🟢 📞 mcp_server.py:165 [LOW] (db = Database(source_path)...)

  Enhanced:
  🟢 📞 mcp_server.py:165:30 [MEDIUM] Database(source_path) → constructor call
        ├─ Context: async function call_tool() → conditional reinitalization block
        ├─ AST: assignment_statement → call_expression → identifier
        ├─ Pattern: Database initialization in conditional branch
        ├─ Risk: Called conditionally when current_project != project_root
        └─ Impact: Creates new database connection, reinitializes system state

  Value Proposition Scoring:

  1. Precise Column Location - ⭐⭐⭐⭐

  Addition: :30 (exact column)Value: Enables editor jump-to-exact-position, better than file:line approximation
  Use case: IDE integration, precise navigation

  2. AST Context Information - ⭐⭐⭐⭐⭐

  Addition: assignment_statement → call_expression → identifier
  Value: Shows structural context, not just text match - proves it's actual constructor call
  Use case: Eliminates false positives, confirms usage type

  3. Parent Function Context - ⭐⭐⭐⭐⭐

  Addition: async function call_tool() → conditional reinitalization blockValue: Shows architectural context -
  this is system initialization code
  Use case: Understanding change impact scope

  4. Usage Pattern Recognition - ⭐⭐⭐⭐⭐

  Addition: Database initialization in conditional branch
  Value: Identifies this as conditional initialization pattern vs regular usage
  Use case: Risk assessment for refactoring

  5. Risk Enhancement - ⭐⭐⭐⭐⭐

  Addition: Risk level change from [LOW] to [MEDIUM] due to conditional context
  Value: More accurate risk assessment based on structural analysis
  Use case: Better refactoring decision making

  6. Impact Analysis - ⭐⭐⭐⭐

  Addition: Creates new database connection, reinitializes system state
  Value: Shows side effects and system impact of this specific usage
  Use case: Change planning and testing scope

  Overall Enhancement Value: ⭐⭐⭐⭐⭐

  Highest value additions:
  1. AST Context - Proves it's real usage, not text match
  2. Parent Function Context - Shows architectural significance
  3. Usage Pattern Recognition - Enables pattern-based refactoring decisions
  4. Enhanced Risk Assessment - More accurate than text-based heuristics

  The AST-grep enhancements transform basic location info into comprehensive architectural intelligence.



  🟢 📞 mcp_server.py:165:30 [MEDIUM] Database(source_path) → constructor call
        ├─ Context: async function call_tool() → conditional reinitalization block
        ├─ AST: assignment_statement → call_expression → identifier
        ├─ Symbol: class Database defined in database.py:9
        ├─ Constructor: __init__(self, source_path: str)
        ├─ Available methods: add_file, add_chunk, get_file_info, close, delete_file
        │  └─ add_code_chunk(file_id: int, chunk_data: dict[str, Any]) -> int
        │  └─ search_ast_nodes(...) -> list[dict[str,Any]]
        │  └─ get_all_code_chunks() -> list[dict[str,Any]]
        └─ Type signature: Database(source_path: str) -> Database

  Ctags Value Assessment:

  1. Symbol Hierarchy - ⭐⭐

  Real addition: Shows 23 available Database methods
  Value: Helps understand what operations are possible on this Database instance
  Practical use: "After creating Database(source_path), you can call .add_file(), .close(), etc."

  2. Type Signatures - ⭐⭐⭐

  Real addition: __init__(self, source_path: str), add_chunk() -> int
  Value: Shows expected parameters and return types for available methods
  Practical use: Validates parameter usage, shows return type expectations

  3. Definition Source - ⭐

  Real addition: class Database defined in database.py:9
  Value: Redundant - already shown by current refs
  Practical use: Jump to definition (but CCLSP already provides this)

● You're absolutely right! If we're controlling all tool calls from core.sh, we can hardcode the paths and
  eliminate the compatibility issues.

  Controlled Environment Benefits:

  In core.sh we can hardcode:

  # All ctags operations with explicit path
  ctags -f .ast-grep/tags -R --languages=Python *.py
  grep "Database" .ast-grep/tags

  # All ast-grep operations with explicit config
  ast-grep --config=.ast-grep/sgconfig.yml --pattern "Database($$$)"

  # No user/editor dependency on standard locations

  User Never Sees:

  - File paths - they just run m refs Database
  - Tool complexity - core.sh handles all path resolution
  - Configuration details - everything is abstracted

  Implementation Strategy:

  # In core.sh
  TAGS_FILE=".ast-grep/tags"
  ASTGREP_CONFIG=".ast-grep/sgconfig.yml"

  generate_tags() {
      ctags -f "$TAGS_FILE" -R --languages=Python *.py
  }

  enhanced_refs() {
      # Use our controlled paths
      local symbol="$1"
      grep "$symbol" "$TAGS_FILE"
      ast-grep --config="$ASTGREP_CONFIG" --pattern "$symbol($$$)"
  }

  Updated Viability: ⭐⭐⭐⭐⭐

  ✅ Perfect Solution:

  - User simplicity: m refs Database works exactly the same
  - Clean project root: No visible config/data files
  - Tool integration: We control all paths internally
  - No compatibility issues: Users never interact with tools directly
  - Consistent behavior: All complexity hidden in core.sh

  Implementation:

  # Setup function in core.sh
  setup_ast_tools() {
      mkdir -p .ast-grep
      ctags -f .ast-grep/tags -R --languages=Python *.py
      mv sgconfig.yml .ast-grep/ 2>/dev/null || true
  }

  # All refs/find functions use .ast-grep/ paths internally

  Verdict: ⭐⭐⭐⭐⭐ Highly Recommended

  Since users only interact through m commands, we have complete control over file locations and tool arguments.
  This is actually the ideal architecture - clean project root + hidden complexity.

  Action: Move both files to .ast-grep/ and update all internal tool calls to use explicit paths.




















### AST GREP INFO
get official documentation from context7:
`context7 - get-library-docs (MCP)(context7CompatibleLibraryID: "/ast-grep/ast-grep", tokens: 8000)`

the executable `m` should give generic descriptions and comprehensive usage examples only. not
change histories ensure all functionalities are represented here.




## VALUE PROPOSITIONS
1. ARCHITECTURAL SAFETY ANALYSIS ⭐⭐⭐⭐⭐
"What breaks if I change this?"
Core Ideal: Transform abstract code relationships into concrete, actionable safety information for confident
refactoring decisions.
Fundamental Principles:
- Every change impact must be expressed as specific file:line locations
- Relationship analysis provides transitive dependency chains with distance tracking
- Coupling analysis identifies functions requiring careful change management
- Impact prediction enables "blast radius" assessment before modifications
Value Delivery:
- Eliminates guesswork in large codebases
- Prevents cascade failures from seemingly safe changes
- Enables confident refactoring of legacy systems
- Reduces time spent debugging broken dependencies
2. DISCOVERY-DRIVEN DEVELOPMENT ⭐⭐⭐⭐⭐
"Find not just where code is, but what it does and how it fits"
Core Ideal: Bridge the gap between semantic intent and structural implementation through intelligent pattern
recognition.
Fundamental Principles:
- Semantic similarity reveals functionally equivalent code
- Behavioral categorization groups code by purpose, not structure
- Usage pattern analysis shows how code is actually employed
- Cross-referencing validates assumptions about code relationships
Value Delivery:
- Accelerates understanding of unfamiliar codebases
- Identifies refactoring opportunities through similarity analysis
- Reveals architectural patterns and anti-patterns
- Enables knowledge transfer through pattern documentation
3. CONCRETE ACTIONABILITY ⭐⭐⭐⭐⭐
"No abstract metrics, just specific locations and actions"
Core Ideal: Every analysis result must directly translate to executable developer actions.
Fundamental Principles:
- Replace complexity scores with specific problematic locations
- Provide exact file:line references for all findings
- Include concrete suggestions for improvement
- Validate all recommendations through relationship analysis
Value Delivery:
- Eliminates analysis paralysis from abstract measurements
- Enables immediate action on identified issues
- Reduces cognitive load by providing clear next steps
- Builds developer confidence through specific guidance
SECONDARY VALUE PROPOSITIONS
4. CONTEXTUAL CODE COMPREHENSION ⭐⭐⭐⭐
"Understanding code through its relationships and usage"
Core Ideal: Code understanding emerges from relationship context, not isolated analysis.
Fundamental Principles:
- Functions are understood through their callers and callees
- Similar functions reveal architectural patterns
- Usage contexts show intended vs actual behavior
- Configuration dependencies expose external influences
Value Delivery:
- Faster onboarding to complex codebases
- Better architectural decision-making
- Reduced misunderstanding of code intent
- Improved code review quality
5. ORPHAN AND DEBT DETECTION ⭐⭐⭐⭐
"Identify what becomes obsolete before it becomes technical debt"
Core Ideal: Proactive identification of code that will become abandoned or problematic.
Fundamental Principles:
- Dead code detection through reference analysis
- Orphaned test identification via naming patterns
- Unused configuration tracking
- Single-point-of-failure detection
Value Delivery:
- Prevents accumulation of technical debt
- Enables safe cleanup of legacy code
- Reduces maintenance burden
- Improves codebase health metrics
6. CHANGE PROPAGATION ANALYSIS ⭐⭐⭐
"Understand how changes ripple through systems"
Core Ideal: Model software as a network where changes have predictable propagation patterns.
Fundamental Principles:
- Transitive dependency tracking with distance measurement
- Impact node identification for comprehensive change planning
- Coupling metrics to prioritize change order
- Configuration change impact assessment
Value Delivery:
- Enables strategic change planning
- Reduces unexpected side effects
- Improves release planning accuracy
- Supports incremental migration strategies
SUPPORTING CAPABILITIES
7. PATTERN-BASED ARCHITECTURE ANALYSIS ⭐⭐⭐
"Detect architectural patterns and violations"
Core Ideal: Architecture emerges from code patterns, not documentation.
Fundamental Principles:
- Behavioral pattern recognition across functions
- Structural similarity identification
- Anti-pattern detection through coupling analysis
- Architectural boundary validation
Value Delivery:
- Validates architectural assumptions
- Identifies inconsistent implementations
- Guides refactoring priorities
- Supports architectural evolution
8. SEMANTIC CODE NAVIGATION ⭐⭐⭐
"Navigate by meaning, not just structure"
Core Ideal: Code navigation should understand intent, not just syntax.
Fundamental Principles:
- Vector-based semantic similarity
- Contextual relationship weighting
- Multi-modal search (semantic + structural + behavioral)
- Intent-driven discovery
Value Delivery:
- Faster location of relevant code
- Discovery of unexpected relationships
- Improved code exploration efficiency
- Better understanding of code intent
9. EXTENSIBILITY AND EVOLUTION ⭐⭐
"Support additive enhancement without disruption"
Core Ideal: Systems should evolve gracefully without breaking existing functionality.
Fundamental Principles:
- Modular architecture with clear boundaries
- Plugin systems for domain-specific analysis
- Version-independent analysis techniques
- Backward-compatible enhancement patterns
Value Delivery:
- Future-proof analysis capabilities
- Customizable for specific domains
- Incremental adoption possible
- Sustainable long-term evolution
PHILOSOPHICAL FOUNDATIONS
SYSTEMS THINKING
Code exists within interconnected systems where changes have emergent effects beyond immediate scope.
EMPIRICAL EVIDENCE
All analysis must be grounded in observable code behavior, not theoretical models.
COGNITIVE LOAD REDUCTION
Minimize the mental effort required to understand complex systems by providing clear, structured information.
RISK-AWARE DEVELOPMENT
Every development decision should consider potential negative consequences and provide mitigation strategies.
ACTIONABLE INTELLIGENCE
Information without clear next steps is noise; every insight must enable specific developer actions.
CORE SUCCESS METRICS
DEVELOPER VELOCITY
- Time to understand unfamiliar code sections
- Confidence level in making changes
- Accuracy of impact predictions
CODEBASE HEALTH
- Reduction in coupling over time
- Elimination of orphaned code
- Consistency of architectural patterns
CHANGE SAFETY
- Reduced post-deployment issues
- Improved change success rates
- Faster rollback decision-making
KNOWLEDGE TRANSFER
- Onboarding time for new team members
- Code review efficiency
- Architectural decision quality




