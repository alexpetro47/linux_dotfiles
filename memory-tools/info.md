
# INFO


## CLI-ONLY TOOLKIT
- ast-grep (sg) - AST-based code search/rewrite tool
- fzf - Fuzzy finder for interactive selection
- ripgrep (rg) - Fast text search tool
- jq - JSON processor
- bat - Syntax-highlighted file viewer
- miller - Text/CSV data processing tool with SQL-like queries
- fd-find (fd) - Fast alternative to find with intuitive syntax
- sd (better "sed") - Intuitive find-and-replace with regex support
* standard unix tools
  * xargs - 9/10 - Essential pipeline bridge
  * head/tail - 9/10 - Data sampling/log monitoring
  * sort - 8/10 - Pipeline data ordering
  * uniq - 8/10 - Deduplicate (with sort)
  * wc - 7/10 - Quick counts
  * awk - 7/10 - Column processing when miller overkill


## M COUPLING
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



## M REFS
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

---






