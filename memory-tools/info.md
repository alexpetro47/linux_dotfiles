
# INFO



* must run `sem-index` in cli before `m find` s.t. db is available.

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








## "M FIND"
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





## "M TRACE" 
* `trace` - comprehensive information about a symbol and all of its relationships.
inherently specific & ideally 1-2 results per, verbose per result.

### TOOLS
* ctags
* ripgrep
* ast-grep


### CONTENTS
```
***CLASSES + INTERFACES + STRUCTS***
- 📖 DEFINED AT - definition location
- 🔧 METHOD CATALOG - constructors, methods, signatures, parameters, returns
- 🏷️  SYMBOL METADATA - access modifiers, decorators, annotations, docstrings
- 📦 IMPORTED BY - files that import this symbol
- 📞 CALLED BY - filepath:line that call/instantiate this symbol
- 🧬 INHERITANCE HIERARCHY - parent classes, child classes, interface implementations
- 📤📥 PARAMETER/RETURN DEPENDENCIES - shows type usage patterns
- 🚨 EXCEPTION RELATIONSHIPS - affects error handling
- 📦 DEPENDENCIES - what this symbol uses/depends on
- 🔗 COMPOSITION/AGGREGATION - objects that contain this symbol as field/property

***FUNCTIONS + METHODS + PROTOTYPES***
- 📖 DEFINED AT
- 📋 SIGNATURE - parameters, return type, exceptions
- 🏷️ SYMBOL METADATA - decorators, access modifiers, async/static flags, docstrings
- 📞 CALLED BY
- 📦 DEPENDENCIES - what it calls/imports
- 📤📥 PARAMETER/RETURN USAGE - how its types flow
- 📦 IMPORTED BY
- 🚨 EXCEPTION RELATIONSHIPS - throws/catches analysis
- 🔧 PARAMETER DETAILS - defaults, type annotations, variadic args

***VARIABLES + CONSTANTS + FIELDS + PROPERTIES***
- 📖 DEFINED AT + TYPE
- 🏷️ SYMBOL METADATA - scope (global/local/class), mutability, access modifiers
- 📝 ASSIGNMENTS - where modified
- 📍 REFERENCES - where used
- 🔄 VALUE FLOW - assignment → usage chains
- 💎 VALUE ANALYSIS - literal values, computed expressions, type inference

***IMPORTS + EXPORTS***
- 📖 DEFINED AT - import/export statements
- 🔗 SOURCE MAPPING - which module/file provides the symbol
- 📦 USAGE ANALYSIS - how imported symbols are used
- 🌐 NAMESPACE RESOLUTION - aliasing, wildcard imports, conflicts

***MODULES + NAMESPACES***
- 📦 EXPORTS - public API
- 📦 IMPORTS - dependencies
- 📞 USAGE - who imports this
- 🏗️  STRUCTURE - internal organization
```

### OUTPUT FORMATTING
```
  📖 DEFINED AT: database.py:9
      class Database(BaseModel):

  🔧 METHOD CATALOG:
      __init__(self, source_path: str) -> None
      add_file(self, file_path: str, content: str) -> int
      get_file_info(self, file_id: int) -> Optional[dict]
      close(self) -> None

  🏷️  SYMBOL METADATA:
      Access: public class
      Inheritance: extends BaseModel
      Decorators: @dataclass, @cache
      Docstring: "SQLite database interface for code analysis"

  📦 IMPORTED BY:
     doc_parser.py:11
     mcp_server.py:19 
     vector_store.py:7

  📞 CALLED BY:
     mcp_server.py:165  db = Database(source_path)
     ├─ Context: async function call_tool() → initialization
     parse_helpers.py:31  Database(source_path)
     ├─ Context: function parse_code_file() → main processing

  🧬 INHERITANCE HIERARCHY:
     Parents: BaseModel (pydantic.main:BaseModel)
     Children: SQLiteDatabase (database/sqlite.py:15)
               PostgresDatabase (database/postgres.py:23)
     Implements: DatabaseInterface (interfaces.py:45)

  📤📥 PARAMETER/RETURN USAGE:
     ACCEPTS Database:
      backup_database(db: Database) → utils.py:45
      validate_schema(db: Database) → validation.py:23
    RETURNS Database:
      get_default_db() → Database → config.py:78

  🚨 EXCEPTION RELATIONSHIPS:
  THROWS:
      DatabaseError → database.py:156 (connection failures)
      ValidationError → database.py:203 (schema validation)
  CATCHES:
      SQLiteError → database.py:89 (handled internally)

  📦 DEPENDENCIES:
      sqlite3 → database.py:3
      pathlib.Path → database.py:4
      pydantic.BaseModel → database.py:5
      typing.Optional, Any → database.py:6

  🔗 COMPOSITION/AGGREGATION:
      DatabaseManager.primary_db: Database → manager.py:15
      BackupService.source_db: Database → backup.py:28
      TestFixture.test_db: Database → conftest.py:67

  📋 SIGNATURE:
      parse_file(file_path: str, options: ParseOptions = None) -> ParseResult
      Throws: FileNotFoundError, ParseError

  📝 ASSIGNMENTS:
      config.py:12 DATABASE_URL = "sqlite:///data.db"
      settings.py:34 DATABASE_URL = os.getenv("DB_URL")
      test_config.py:8 DATABASE_URL = "sqlite:///:memory:"

  📍 REFERENCES:
      database.py:45 connection = sqlite3.connect(DATABASE_URL)
      backup.py:23 if DATABASE_URL.startswith("sqlite"):
      utils.py:67 logger.info(f"Connecting to {DATABASE_URL}")

  🔄 VALUE FLOW:
      config.py:12 → database.py:45 → backup.py:23
      settings.py:34 → utils.py:67 → logger output

  📦 EXPORTS:
      Database (class) → __init__.py:15
      parse_file (function) → __init__.py:16
      DatabaseError (exception) → __init__.py:17

  🏗️  STRUCTURE:
      database/
      ├── __init__.py (public API)
      ├── core.py (Database class)
      ├── utils.py (helper functions)
      └── exceptions.py (error types)
```




1. ctags provides universal symbol definitions
2. ast-grep enhances metadata for Python/JS/TS/Go/Rust
3. ripgrep handles all reference finding



IMPLEMENTATION COMPLEXITIES

  SYMBOL DISAMBIGUATION

  - Multiple definitions - Database class vs database variable vs database module
  - Overloaded methods - same name, different signatures
  - Shadowing - local variables hiding class members
  - Solution: Use file:line precision + signature matching




CTAGS AS UNIVERSAL FOUNDATION

- Universal Ctags already handles 40+ languages
- Provides consistent symbol definitions across languages
- Use as primary source, fallback to ast-grep for specifics

SEMANTIC PATTERNS OVER SYNTAX

# Instead of hardcoding syntax per language
rg "class.*Database" --type py
rg "class Database" --type js
rg "struct Database" --type rust

# Use semantic patterns
rg "(class|struct|interface|type).*Database"

CONFIGURATION-DRIVEN AST-GREP

# config/languages.yml
inheritance:
  python: "class $NAME($PARENT)"
  typescript: "class $NAME extends $PARENT"
  java: "class $NAME extends $PARENT"

composition:
  python: "$NAME: $TYPE"
  typescript: "$NAME: $TYPE"

LANGUAGE DETECTION + DELEGATION

case "$(file --mime-type "$file")" in
  *python*) use_python_patterns ;;
  *javascript*) use_js_patterns ;;
  *) use_generic_ripgrep_fallback ;;
esac

PROGRESSIVE ANALYSIS

1. Level 1: Universal (ctags + ripgrep) - works everywhere
2. Level 2: Common patterns (ast-grep configs for mainstream languages)
3. Level 3: Language-specific (only when needed)

This keeps 80% functionality universal while allowing language-specific depth.



---



❯ ast-grep --lang python -p 'load_agent' .
load_coordination.py
19│from load_agent import create_generic_agent_node

load_agent.py
278│def load_agent(
354│            agent = load_agent(final_agent_id)






LEVEL 1: MINIMAL VIABLE TRACE

Core functionality:
- 📖 DEFINED AT - use ctags to find symbol definition
- 📍 REFERENCES - use ripgrep to find all usage locations

Implementation:
# Basic trace command
m trace <symbol_name>

# Tools:
ctags --list-tags | grep "$symbol_name"  # definition
rg "$symbol_name" --line-number          # references

LEVEL 2: ADD SYMBOL METADATA

Enhanced with:
- 🏷️  SYMBOL METADATA - parse ctags for type, signature details
- 📋 SIGNATURE - extract function parameters, return types

LEVEL 3: BASIC DEPENDENCIES

Add:
- 📦 DEPENDENCIES - what the symbol imports/uses (ripgrep for import statements)
- 📦 IMPORTED BY - files that import this symbol


