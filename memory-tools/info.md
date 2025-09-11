
# INFO

#### TODOS
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
* also consider
  * duplo
  * hash based matching
  * pmd cpd
  * lizard
  * sonar qube


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


## "M TRACE" 
just use cclsp find_references














