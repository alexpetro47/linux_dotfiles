
# INFO


## DEPENDENCIES
* must run `sem-index` in cli before `m find` s.t. db is available.
  * depends on project `/home/alexpetro/Documents/code/memory_mcp/`

* tree-sitter-cli installed (via cargo-binstall) and grammars installed in
`~.config/tree-sitter/ <python, js, etc>`

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
* tree-sitter-cli
* standard unix tools
  * xargs - 9/10 - Essential pipeline bridge
  * head/tail - 9/10 - Data sampling/log monitoring
  * sort - 8/10 - Pipeline data ordering
  * uniq - 8/10 - Deduplicate (with sort)
  * wc - 7/10 - Quick counts
* cli semantic search tools `sem-index` to create `.m/memory.db` and `sem-search
"query contents"` to search the db


## "M FIND"
* `find` - find all possible semantically/fuzzily similar things, identify which one(s) are
relevant. include context of what each thing is to select intelligently, include enough of a
signature to inform `refs` precisely. deduplicated always. inherently broad, non-verbose per
result.
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










## TODOS
* integrate semantic search into "find" from memory_mcp project
* how to make this functional cross language? (python and js/ts/tsx/html/css primarily)
* add quick-transformation patterns as well? utilizing 
* for ./m or ./m/memory.db placement always check all parent dirs otherwise put in cwd.



`m trace create_agent /home/alexpetro/Documents/code/adaas-poc/load_agent.py 159`


improvements 
























## IDEOLOGY

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





















## "M TRACE" 
* `trace` - comprehensive information about a symbol and all of its relationships.
inherently specific & ideally 1-2 results per, verbose per result.




now using tree-sitter-cli from cargo binstall










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


---


● The Context7 documentation for ast-grep primarily shows basic CLI usage but doesn't provide the detailed
  pattern syntax for identifying different types of content. Based on the ast-grep documentation available,
  here's what I can determine about how to find each type of content:

  Basic Pattern Syntax

  - $VARIABLE - captures any expression/identifier
  - sg -p 'pattern' -l language - basic search pattern
  - sg -p 'pattern' -r 'replacement' -l language - find and replace

  How to Find Each Content Type:

  CLASSES + INTERFACES + STRUCTS
  - Class definitions: sg -p 'class $NAME { $$$ }' -l ts
  - Interface definitions: sg -p 'interface $NAME { $$$ }' -l ts
  - Constructor calls: sg -p 'new $CLASS($$$)' -l ts
  - Method calls: sg -p '$OBJ.$METHOD($$$)' -l ts

  FUNCTIONS + METHODS + PROTOTYPES
  - Function definitions: sg -p 'function $NAME($$$) { $$$ }' -l js
  - Arrow functions: sg -p '$NAME = ($$$) => $$$' -l js
  - Method definitions: sg -p '$NAME($$$) { $$$ }' -l ts
  - Function calls: sg -p '$FUNC($$$)' -l js

  VARIABLES + CONSTANTS + FIELDS + PROPERTIES
  - Variable declarations: sg -p 'var $NAME = $VALUE' -l js
  - Let declarations: sg -p 'let $NAME = $VALUE' -l js
  - Const declarations: sg -p 'const $NAME = $VALUE' -l js
  - Property access: sg -p '$OBJ.$PROP' -l js
  - Assignments: sg -p '$VAR = $VALUE' -l js

  IMPORTS + EXPORTS
  - ES6 imports: sg -p 'import $NAME from $MODULE' -l js
  - Named imports: sg -p 'import { $$$ } from $MODULE' -l js
  - Export statements: sg -p 'export $$$' -l js
  - Require statements: sg -p 'require($MODULE)' -l js

  MODULES + NAMESPACES
  - Module exports: sg -p 'module.exports = $$$' -l js
  - Namespace declarations: sg -p 'namespace $NAME { $$$ }' -l ts

  The $$$ wildcard captures multiple statements/expressions, while $VARIABLE captures single elements.
  Language-specific patterns would need to be adjusted based on the target language syntax.

> redo for python

● Based on the ast-grep documentation and Python syntax, here's how to find each type of content in Python:

  How to Find Each Content Type in Python:

  CLASSES + INTERFACES + STRUCTS
  - Class definitions: sg -p 'class $NAME: $$$' -l py
  - Class with inheritance: sg -p 'class $NAME($PARENT): $$$' -l py
  - Class instantiation: sg -p '$NAME($$$)' -l py
  - Method calls: sg -p '$OBJ.$METHOD($$$)' -l py
  - Constructor calls: sg -p '$CLASS.__init__($$$)' -l py

  FUNCTIONS + METHODS + PROTOTYPES
  - Function definitions: sg -p 'def $NAME($$$): $$$' -l py
  - Method definitions: sg -p 'def $NAME(self, $$$): $$$' -l py
  - Lambda functions: sg -p 'lambda $$$: $$$' -l py
  - Function calls: sg -p '$FUNC($$$)' -l py
  - Async functions: sg -p 'async def $NAME($$$): $$$' -l py
  - Decorated functions: sg -p '@$DECORATOR\ndef $NAME($$$): $$$' -l py

  VARIABLES + CONSTANTS + FIELDS + PROPERTIES
  - Variable assignments: sg -p '$VAR = $VALUE' -l py
  - Multiple assignments: sg -p '$A, $B = $$$' -l py
  - Augmented assignments: sg -p '$VAR += $VALUE' -l py
  - Global variables: sg -p 'global $VAR' -l py
  - Class attributes: sg -p 'self.$ATTR = $VALUE' -l py
  - Property decorators: sg -p '@property\ndef $NAME(self): $$$' -l py

  IMPORTS + EXPORTS
  - Basic imports: sg -p 'import $MODULE' -l py
  - From imports: sg -p 'from $MODULE import $NAME' -l py
  - Aliased imports: sg -p 'import $MODULE as $ALIAS' -l py
  - Wildcard imports: sg -p 'from $MODULE import *' -l py
  - Relative imports: sg -p 'from .$MODULE import $NAME' -l py

  MODULES + NAMESPACES
  - Module-level assignments: sg -p '__all__ = [$$$]' -l py
  - If main block: sg -p 'if __name__ == "__main__": $$$' -l py
  - Module docstrings: sg -p '"""$$$"""' -l py

  PYTHON-SPECIFIC PATTERNS
  - Try/except blocks: sg -p 'try: $$$\nexcept $EXCEPTION: $$$' -l py
  - Context managers: sg -p 'with $CONTEXT as $VAR: $$$' -l py
  - List comprehensions: sg -p '[$EXPR for $VAR in $ITERABLE]' -l py
  - Dictionary comprehensions: sg -p '{$KEY: $VALUE for $VAR in $ITERABLE}' -l py
  - Generator expressions: sg -p '($EXPR for $VAR in $ITERABLE)' -l py

  The $$$ wildcard captures multiple statements, $VARIABLE captures single elements, and patterns must match
  Python's indentation-based syntax structure.

---



  ⎿  Function name: load_agent
     Line number: 278
     Arguments:
       - agent_id
       - anthropic_api_key
       - modelpack
     Defaults:
       - None
       - None
     Decorators:
     Return annotation:
       - Name(id='ConfigurableAgent', ctx=Load())
     Docstring:
       - Convenience function to load an agent.
     Body statements count: 3




---

##   WHAT UV RUN PYTHON -C AST.PARSE() CAN EXTRACT PERFECTLY:

  ✅ COMPLETE COVERAGE:
  - 📖 DEFINED AT - line numbers, column positions
  - 📋 SIGNATURE - parameters, type annotations, return types, defaults
  - 🏷️  SYMBOL METADATA - decorators, docstrings, async/static flags, access patterns
  - 🔧 METHOD CATALOG - complete class method inventory with signatures
  - 🧬 INHERITANCE HIERARCHY - parent classes (from class definition)
  - 📦 DEPENDENCIES - imports, internal function calls within file
  - 💎 VALUE ANALYSIS - literal values, computed expressions
  - 🚨 EXCEPTION RELATIONSHIPS - explicit raise/except within functions

  What ast.parse() CANNOT extract (requires cross-file analysis):

  ❌ CROSS-FILE RELATIONSHIPS:
  - 📞 CALLED BY - where symbols are used across codebase
  - 📦 IMPORTED BY - which files import this symbol
  - 🧬 Child classes - what inherits from this class
  - 📤📥 PARAMETER/RETURN USAGE - type flow across module boundaries
  - 🔗 COMPOSITION/AGGREGATION - where class is used as field elsewhere
  - 📍 REFERENCES - cross-file variable usage
  - 🔄 VALUE FLOW - assignment chains across files
  - 📞 USAGE - who imports this module

---





What tree-sitter CAN find (7-9/10):
Structural Analysis

✅ DEFINED AT - Node positions, line/column info
✅ SIGNATURES - Function parameters, return types (if annotated)
✅ INHERITANCE HIERARCHY - Parent classes in syntax tree
✅ IMPORTS/EXPORTS - All import statements, module structure
✅ SYMBOL METADATA - Decorators, access modifiers, docstrings
✅ ASSIGNMENTS - All variable assignments
✅ LITERAL VALUES - Constants, expressions

What tree-sitter CANNOT find (0-3/10):
Semantic Analysis

❌ IMPORTED BY - No cross-file analysis
❌ CALLED BY - No reference resolution
❌ USAGE ANALYSIS - Can't resolve symbol references
❌ TYPE INFERENCE - Only sees explicit annotations
❌ VALUE FLOW - No data flow analysis
❌ COMPOSITION/AGGREGATION - No semantic understanding



Yes - You can create a hybrid approach combining both tools:
Architecture
tree-sitter handles syntax parsing and structural analysis, while LSP provides semantic understanding and cross-file relationships. Script coordinates between both.
Information Flow

tree-sitter parses file → extracts symbol locations, signatures, syntax structure
LSP receives symbol position → resolves references, types, cross-file relationships
Script merges both datasets → comprehensive symbol analysis

Division of Labor
tree-sitter provides:

Exact syntax positions for targeting LSP queries
Local structural context (class hierarchy, method signatures)
Fast initial symbol discovery and filtering

LSP provides:

Cross-file references (IMPORTED BY, CALLED BY)
Type resolution and inference
Semantic understanding (what calls what)
Workspace-wide symbol relationships

Process Benefits
Efficiency: tree-sitter's speed for bulk parsing + LSP's precision for specific queries
Completeness: Syntax structure + semantic relationships
Accuracy: LSP's type system validates tree-sitter's structural findings
Script Workflow
Parse with tree-sitter → identify target symbols → query LSP for each symbol → correlate positions → build comprehensive relationship map
Coverage: ~95% of your original requirements - combines structural completeness with semantic accuracy.
Performance: Fast initial discovery, targeted semantic queries only where needed.

Rationale: Both tree-sitter and most LSPs have excellent JS bindings
LSP: Built-in JSON-RPC, widespread LSP client libraries
tree-sitter: Native Node.js bindings, mature ecosystem
Install: bun add -g tree-sitter @typescript-eslint/parser vscode-languageserver && which node




  Global Script Location ✅

   Script in ~/.config/memory-tools/
   Callable from any project directory
  m trace Database ./src/models.py:45

  Per-Project LSP Requirements ❌⚠️ 

  The problem: LSP servers need project-specific setup:

  // Each project directory needs:
  - package.json / pyproject.toml (dependencies)
  - tsconfig.json / pyrightconfig.json (language config)
  - LSP server initialization in project root
  - Project-specific type information

  Practical Solutions:

  Option 1: Auto-detect project setup
  // In your script
  const projectRoot = findProjectRoot(symbolFile); // walk up for package.json
  process.chdir(projectRoot);
  const lspServer = startLSP(detectLanguage(symbolFile));

  Option 2: Graceful degradation
  // Try LSP first, fallback to tree-sitter only
  try {
    const lspData = await queryLSP(symbol, position);
  } catch {
    console.warn("LSP unavailable, using tree-sitter only");
    return treeitterOnlyAnalysis(symbol);
  }

  Option 3: Project-agnostic mode
  // Skip workspace-dependent features
  // Focus on single-file analysis + basic cross-file text search
  // Combine tree-sitter + ripgrep instead of full LSP

  Reality Check:

  For true project-agnostic operation, you might want:
  - Tree-sitter for syntax parsing
  - Ripgrep for cross-file references
  - Skip full LSP semantic analysis

  This gives you ~80% of the benefits without project setup complexity.

  Recommendation: Start with tree-sitter + ripgrep hybrid for global usage, add LSP as optional enhancement when
  in properly configured projects.


---


  MISSING INFORMATION:

  1. Internal Function Calls

  - Missing: Calls between functions within the same file
  - Example: create_agent() calls load_agent_spec(), _create_llm(), _create_react_prompt() - none shown
  - Expected: Show internal method/function call relationships

  2. Class Method Relationships

  - Missing: Which methods belong to which classes
  - Example: create_agent is a method of AgentLoader class - not indicated
  - Expected: Show class membership and inheritance relationships

  3. Variable/Attribute Usage

  - Missing: Instance variables used within methods
  - Example: self.specs_dir, self.anthropic_api_key in AgentLoader methods
  - Expected: Track attribute access patterns and state usage

  4. Return Type Relationships

  - Missing: What types functions return and how they're used
  - Example: create_agent() returns ConfigurableAgent - relationship not tracked
  - Expected: Type flow analysis showing object creation and usage

  5. Nested Function Analysis

  - Missing: Functions defined inside other functions
  - Example: agent_node() function inside create_generic_agent_node() - not detected
  - Expected: Nested scope analysis and closure relationships

  6. Exception Handling Relationships

  - Missing: What exceptions are raised/caught and where
  - Example: FileNotFoundError, ValueError raised in multiple functions
  - Expected: Error flow analysis across call stack

  7. Control Flow Context

  - Missing: Conditional usage and branching logic
  - Example: When invoke() uses structured output vs fallback behavior
  - Expected: Usage context and conditional call patterns

  8. Data Flow Tracking

  - Missing: How data transforms through function calls
  - Example: agent_spec → extract_inputs_from_state → agent.invoke chain
  - Expected: Parameter/return value flow analysis

  9. External API Usage

  - Missing: Third-party library method calls
  - Example: create_react_agent(), ChatAnthropic(), AgentExecutor() usage
  - Expected: External dependency call patterns

  10. Scope and Lifetime Analysis

  - Missing: Variable scope boundaries and object lifetimes
  - Example: When variables are created, modified, and go out of scope
  - Expected: Memory and scope management analysis

  The current tool provides good module-level import/export relationships but lacks detailed intra-file analysis
  and semantic code relationships.

