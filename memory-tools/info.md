
# INFO

### TODOS
* integrate semantic search into "find" from memory_mcp project
* how to make this functional cross language? (python and js/ts/tsx/html/css primarily)
* add quick-transformation patterns as well? utilizing 
* for ./m or ./m/memory.db placement always check all parent dirs otherwise put in cwd.


## IDEOLOGY
* `find` - find all possible semantically/fuzzily similar things, identify which one(s) are
relevant. include context of what each thing is to select intelligently, include enough of a
signature to inform `refs` precisely. deduplicated always. inherently broad, non-verbose per
result.



* `trace` (was "refs")- find all relations of that thing around codebase. dependencies,
reverse-dependencies, recursive/transitive deps, etc. returns precise locations,
usage, args/returns/throws/etc. function/class/var/interface/etc relationships. inherently
specific, verbose per result - ideally 1 result.

* `arch` (was "coupling") - quantitative measurement + identify problem areas for modular
black-box style architecture ideals. 
1. Import Fan-Out (3-8 per file) ⭐⭐⭐⭐⭐
  - Measurable: Count imports per file
  - Balanced: Prevents god objects without forcing micro-modules
  - Actionable: >8 imports = clear refactoring target
  - Reality-friendly: Allows reasonable composition
2. Change Coupling (>70% co-commits) ⭐⭐⭐⭐⭐
  - Measurable: Git log analysis of files changing together
  - Balanced: Identifies actual architectural problems, not theoretical
  - Actionable: Shows exactly which boundaries are wrong
  - Reality-friendly: Based on real development patterns
3. Circular Dependencies (zero tolerance) ⭐⭐⭐⭐⭐
  - Measurable: Static analysis for import cycles
  - Balanced: Binary metric - clear architectural violation
  - Actionable: Always indicates specific refactoring need
  - Reality-friendly: Unambiguous problem, not subjective
4. File Length (200-400 lines) ⭐⭐⭐⭐
  - Measurable: Line count per file
  - Balanced: Prevents massive files but allows cohesion
  - Actionable: >400 lines = split target
  - Reality-friendly: Human-readable size limits
5. Dead Code Rate (<5%) ⭐⭐⭐⭐
  - Measurable: Unused imports/functions percentage
  - Balanced: Allows some experimental code, prevents cruft
  - Actionable: Direct cleanup targets
  - Reality-friendly: Easy wins that improve maintainability
6. Parameter Count (>5 suggests missing abstraction) ⭐⭐⭐⭐
  - Why it almost made it: Directly identifies design problems
  - Measurable: Count function parameters across codebase
  - Actionable: >5 parameters = extract object/config pattern
  - Complementary: Works with Import Fan-Out to show abstraction gaps
7. Function Length (>50 lines) ⭐⭐⭐⭐
  - Why it almost made it: More granular than file length
  - Measurable: Lines per function
  - Actionable: Clear extraction targets
  - Complementary: File length catches big problems, this catches local complexity
8. Import Fan-In (>15 dependents) ⭐⭐⭐
  - Why it almost made it: Identifies bottleneck/god modules
  - Measurable: Count files importing this one
  - Actionable: Shows modules that need interface splitting
  - Complementary: Fan-out shows complexity, fan-in shows fragility

* `diffs` - parsing of git diffs to validate implementations

* `transform` - make changes via ast-grep, sd, jq, yq, miller (utilize pre-validated
filepath+line results)

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
* git (--no-pager diff HEAD, log)
* standard unix tools
  * xargs - 9/10 - Essential pipeline bridge
  * head/tail - 9/10 - Data sampling/log monitoring
  * sort - 8/10 - Pipeline data ordering
  * uniq - 8/10 - Deduplicate (with sort)
  * wc - 7/10 - Quick counts
* cli semantic search tools `sem-index` to create `.m/memory.db` and `sem-search
"query contents"` to search the db

 

also consider
* duplo
* hash based matching
* pmd cpd
* lizard
* sonar qube




## ARGS
+ good default thresholds + ranking, sorting

***Target Types (what you're searching for):***
--target=content|symbol|structure|file|config|test|doc|history
--lang=py/js+ts+tsx/etc

***Search Strategies (precision/recall trade-off):***
--strategy=precise|balanced|broad
* precise: ctags → ast-grep → regex
* balanced: ripgrep + fuzzy (default)
* broad: semantic + fuzzy + typo-tolerant

***Scope Filtering (where to look):***
--in=functions|classes|tests|imports|comments|files|all
--lang=py|js|rs|go  # Language-specific filtering
--depth=1-5         # Directory depth limit
--subdir=subdir/path/

***temporal filtering***
--timestamp
--git diff HEAD, logs

***result control***
--limit=N           # Max results
--show-context=3    # Lines of context around matches
--format= ??



## current implementations
### "M FIND"
```
● Bash(m find "GraphStore")
  ⎿  === 🔍 SEMANTIC SEARCH: GraphStore ===
        from graph_store import GraphStore
        graph_store: GraphStore | None = None
        graph_store = GraphStore(source_path)
        graph_store = GraphStore(source_path)
        graph_store = GraphStore(source_path)
        from graph_store import GraphStore
        graph_store: GraphStore | None = None,
        graph_store = GraphStore(source_path)
        graph_store: GraphStore | None = None,
        graph_store = GraphStore(source_path)
        class GraphStore
        from graph_store import GraphStore
        graph_store = GraphStore(self.temp_dir)
        graph_store = GraphStore(self.temp_dir)
        graph_store = GraphStore(self.temp_dir)
        graph_store = GraphStore(large_temp_dir)
        from graph_store import GraphStore
        self.graph_store = GraphStore(self.temp_dir)
        from graph_store import GraphStore
        self.graph_store = GraphStore(self.temp_dir)
        """Unit tests for GraphStore."""
        from graph_store import GraphStore
        class TestGraphStore(TestCase)
        """Test cases for GraphStore functionality."""
        self.graph_store = GraphStore(self.temp_dir)
        """Test GraphStore initialization."""
        # Create new GraphStore instance (should load saved graph)
        new_graph_store = GraphStore(self.temp_dir)
        from graph_store import GraphStore
        graph_store = GraphStore(self.temp_dir)
        graph_store = GraphStore(self.temp_dir)
```

### "M REFS"
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

### "M COUPLING"
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




## consolidated dir for all tool configs/caches
```
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
```




















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






  FZF LIMITATIONS FOR SEMANTIC SEARCH

  fzf's fuzzy matching is character-based, not semantic:
  - "store" → "storage" ❌ (no shared character sequence)
  - "store" → "stroe" ✅ (typo tolerance)
  - "store" → "Store" ✅ (case insensitive)

  fzf excels at:
  - Typo tolerance - databse finds database
  - Partial matches - stor finds datastore
  - Character transposition - stroe finds store

  BETTER SEMANTIC OPTIONS

  For synonym/semantic discovery:
  # Semantic layer via word embeddings
  memory_mcp          - Vector similarity search
  wordnet/thesaurus   - Explicit synonym lookup
  stemming tools      - Root word matching

  Hybrid approach for comprehensive find:
  # 1. Primary discovery (exact + fuzzy)
  rg + ctags + fzf → finds exact matches + typos

  # 2. Semantic expansion (if low results)
  memory_mcp → finds conceptually similar terms

  # 3. Combine results
  sort/uniq → deduplicated comprehensive list

  fzf is perfect for interactive filtering of results, but semantic discovery needs a different engine first.







  Intelligent Defaults

  m find "Database"
  # Auto-detects: likely symbol search
  # Uses: balanced strategy, recent files prioritized
  # Returns: top 10 results, grouped by relevance

  m find "*.py"
  # Auto-detects: file search
  # Uses: precise strategy, fd backend

  m find "error handling"
  # Auto-detects: content search with semantic expansion
  # Uses: broad strategy, includes comments/docs

  Search Type Stacks

  Precision Stack (eliminate false positives):
  1. ctags symbol lookup
  2. ast-grep structural patterns
  3. ripgrep with word boundaries
  4. Fallback to basic grep

  Discovery Stack (maximize recall):
  1. Semantic similarity (embeddings)
  2. Fuzzy matching with typo tolerance
  3. Regex with relaxed patterns
  4. Full-text search

  Balanced Stack (default):
  1. ripgrep with smart patterns
  2. Fuzzy fallback for typos
  3. Context-aware ranking
  4. Semantic expansion for low results



  modular architecture
  - structure projects into isolated modules with single-owner responsibility
  - implement black-box encapsulation with well-documented APIs as exclusive interfaces
  - separate core logic from UI to ensure independent, reusable application cores

  Coupling directly enforces these principles:

  1. Module isolation: High coupling = failed encapsulation
  2. Single responsibility: Files with 15+ dependencies violate single ownership
  3. API boundaries: Coupling shows where clean interfaces break down

  M coupling becomes your architecture validator:

  m coupling --threshold=10     # Enforce low coupling limits
  m coupling --api-boundary     # Check interface violations
  m coupling --by-module        # Module-level coupling analysis

  Critical for your black-box principle - coupling analysis reveals:
  - Which modules have "leaked" internals (high external coupling)
  - Where APIs aren't truly exclusive interfaces (cross-module coupling)
  - Files that violate single-owner responsibility (too many dependencies)

  Without coupling analysis, you can't verify your modular architecture is actually working. It's the difference
  between claiming black-box design and proving it through measurable dependency constraints.

  Coupling is your architectural verification tool - essential for maintaining the clean boundaries your slash
  commands demand.


  File-Level Perfection:
  - Each file: exactly one responsibility, ~200-300 lines max
  - Imports: 3-5 focused dependencies (not 23!)
  - Zero circular dependencies, ever
  - Clear public/private boundaries
  - High cohesion within, minimal coupling between

  Module-Level Perfection:
  - Complete black-box encapsulation - no implementation leakage
  - Stable APIs that never break (only extend)
  - All external dependencies wrapped in custom layers
  - Unidirectional dependency flow
  - Each module independently testable/deployable

  System-Level Perfection:
  - Core logic completely UI/infrastructure-agnostic
  - No framework lock-in through abstraction layers
  - Plugin architectures for all extensibility
  - Only additive changes, never breaking modifications
  - "Finished" code requiring no future revision

  But the trade-offs are brutal:
  - Over-engineering: Wrapping every dependency adds complexity
  - Analysis paralysis: Perfect interfaces upfront prevent iteration
  - Velocity killer: Strict modularity slows initial development
  - Cognitive overhead: 100 tiny modules vs 10 cohesive ones
  - Domain evolution: Requirements change, boundaries shift

  Maybe the real goal: "Good enough modularity" with tools to detect drift. Start pragmatic, use m arch to
  identify when coupling gets dangerous, refactor when metrics scream.

### AST GREP INFO
get official documentation from context7:
`context7 - get-library-docs (MCP)(context7CompatibleLibraryID: "/ast-grep/ast-grep", tokens: 8000)`

the executable `m` should give generic descriptions and comprehensive usage examples only. not
change histories ensure all functionalities are represented here.


---








## FIND TOOL
the find tool is for discovery only. it should categorize outputs by type and give their
exact signatures. it should not provide refs like functionality. it should search widely and
discover each possible variant of a certain term.
deduplicated always. inherently broad, non-verbose per result.

Categorizes by WHAT TYPE of code element - your symbol categories cover all possible code constructs across
languages (class, function, variable, etc.)
Categorizes by WHERE it appears - content (in text/docs) vs structure (filesystem)
Provides exact signatures - enough detail for refs to target the precise element later
This is a clean separation: find discovers ALL variants broadly, then refs does deep relationship analysis on
the specific thing you select.



### **CATEGORIES:**

```
1. symbols [return identifying signature, filepath+line to definition/instantiation]
* class - Class definitions
* function - Function/method definitions
* variable - Variable declarations
* interface - Interface definitions
* struct - Structure definitions
* enum - Enumeration definitions
* typedef - Type definitions
* macro - Preprocessor macros
* namespace - Namespace definitions
* member - Class/struct members
* field - Data fields
* method - Class methods
* property - Object properties
* constant - Constants
* label - Code labels
* prototype - Function prototypes
* module
* decorator

2. content [return contents of line]
* line of content it appears in, documentation-based

3. structure [return filepath]
* dir/subdir/file names
```

### **TOOL SELECTIONS**
```
ripgrep (rg)              - Primary content/symbol search engine
ctags                     - Symbol definitions across languages
fd-find (fd)              - Fast filesystem structure search
sem-index -> sem-search   - semantic search across cwd

  PROCESSING PIPELINE

sort/uniq        - Deduplication of results
head/tail        - Result limiting/sampling
sd               - Text formatting/cleanup
```

### TOOLING RESPONSIBILITIES
```

  symbols: ~85-90% coverage
  - ctags handles well: class, function, variable, interface, struct, enum, typedef, macro, namespace, member,
  field, method, property, constant, label, prototype

  content: ~95% coverage
  - rg handles comprehensively: all text content, comments, documentation, strings, regex patterns
  - minimal gaps: binary files (usually irrelevant), unusual encodings

  structure: ~95% coverage
  - fd handles comprehensively: directories, files, name patterns, extensions, path matching
  - minimal gaps: permission-restricted areas, hidden files (configurable)
```

### FULL LOGIC
```

  Parallel execution strategy:
  # All tools run simultaneously on full codebase
  ctags + rg + fd  →  traditional_results
  sem-search                  →  semantic_results

  # Merge + deduplicate by file:line location
  sort/uniq → comprehensive_deduplicated_results

  Key advantages:
  - no semantic blind spots - traditional tools catch exact matches semantic search might miss
  - no traditional blind spots - semantic search finds conceptual matches traditional tools miss
  - redundancy validation - when both find the same result, higher confidence
  - performance optimization - all tools run concurrently rather than sequentially

  Deduplication logic:
  - by definition location for the same symbols 
  - primary key: file_path:line_number
```

### **OUTPUTS**
```
  📍 SYMBOLS
  class    database.py:9     class Database(BaseModel)
  function helpers.py:45     def get_database() -> Database
  variable config.py:12      DATABASE_URL: str = "sqlite:///"
  constant models.py:8       MAX_DATABASE_CONNECTIONS = 100
  method   database.py:34    def connect(self, url: str)
  property user.py:67        @property def database(self)
  module   __init__.py:1     database
  decorator auth.py:23       @database_transaction

  📝 CONTENT
  README.md:34        "Configure your database connection string"
  parser.py:67        # Database cleanup happens automatically
  errors.py:23        raise DatabaseError("Connection failed")

  🏗️  STRUCTURE
  ./database/
  ./src/database_models.py
  ./tests/test_database.py
  ./config/database.yml
```

Each result shows:
  - Category type (class, function, etc.)
  - Location (file:line) [Definition location only for symbols]
  - Exact signature (enough for refs to target precisely)
Non-verbose, deduplicated, broadly discovers all variants.

#### SEM-SEARCH OUTPUT FOR REFERENCE
```
Result 10 (similarity: 0.139)
File: /home/alexpetro/.config/memory-tools/core.sh:1-50
----------------------------------------

content is here

----------------------------------------
```




s.t.
variable config.py:61   COORDINATION_SPECS_DIR - COORDINATION_SPECS_DIR = get_coordination_specs_dir()
becomes
variable config.py:61   COORDINATION_SPECS_DIR = get_coordination_specs_dir()

