; Import statements
(import_statement
  name: (dotted_name) @import.module) @import

; Import with alias
(import_statement
  name: (aliased_import
    name: (dotted_name) @import_alias.module
    alias: (identifier) @import_alias.alias)) @import_aliased

; From import
(import_from_statement
  module_name: (dotted_name)? @from_import.module
  name: (dotted_name) @from_import.name) @from_import

; From import with alias
(import_from_statement
  module_name: (dotted_name)? @from_import_alias.module
  name: (aliased_import
    name: (identifier) @from_import_alias.name
    alias: (identifier) @from_import_alias.alias)) @from_import_aliased

; From import multiple
(import_from_statement
  module_name: (dotted_name)? @from_import_multi.module
  name: (import_list
    (identifier) @from_import_multi.name)) @from_import_multiple

; Wildcard import
(import_from_statement
  module_name: (dotted_name) @wildcard_import.module
  name: (wildcard_import)) @wildcard_import

; Relative imports
(import_from_statement
  module_name: (relative_module_name
    (import_prefix) @relative_import.prefix
    (dotted_name)? @relative_import.module)
  name: (dotted_name) @relative_import.name) @relative_import