; Variable assignments
(assignment
  left: (identifier) @variable.name
  right: (_) @variable.value) @assignment

; Multiple assignment
(assignment
  left: (pattern_list
    (identifier) @multi_var.name)
  right: (_) @multi_var.value) @multi_assignment

; Augmented assignment
(augmented_assignment
  left: (identifier) @aug_var.name
  operator: (_) @aug_var.operator
  right: (_) @aug_var.value) @augmented_assignment

; Global variables
(global_statement
  (identifier) @global_var.name) @global

; Class attributes
(class_definition
  body: (block
    (expression_statement
      (assignment
        left: (identifier) @class_attr.name
        right: (_) @class_attr.value) @class_attr.assignment)))

; Instance attributes (self.attr = value)
(assignment
  left: (attribute
    object: (identifier) @instance_attr.object
    attribute: (identifier) @instance_attr.name)
  right: (_) @instance_attr.value) @instance_assignment
  (#eq? @instance_attr.object "self")

; Constants (uppercase naming convention)
(assignment
  left: (identifier) @constant.name
  right: (_) @constant.value) @constant_assignment
  (#match? @constant.name "^[A-Z_][A-Z0-9_]*$")

; === ENHANCED VARIABLE ANALYSIS ===

; 1. Variable usage/references (not assignments)
(identifier) @variable_usage
  (#not-has-parent? assignment left)
  (#not-has-parent? function_definition name)
  (#not-has-parent? class_definition name)

; 2. Function parameter usage within function body
(function_definition
  parameters: (parameters
    (identifier) @param.name)
  body: (block
    (identifier) @param_usage.name))
  (#eq? @param.name @param_usage.name)

; 3. Variable scope analysis - local vs global
(function_definition
  body: (block
    (assignment
      left: (identifier) @local_var.name
      right: (_) @local_var.value) @local_assignment))

; 4. Attribute access patterns
(attribute
  object: (identifier) @attr_object.name
  attribute: (identifier) @attr_name.name) @attribute_access

; 5. Variable modifications (augmented assignments)
(augmented_assignment
  left: (identifier) @modified_var.name
  operator: (_) @modified_var.operator
  right: (_) @modified_var.value) @variable_modification

; 6. List/dict subscript access
(subscript
  value: (identifier) @subscript_var.name
  slice: (_) @subscript_key.value) @subscript_access

; 7. Variable in conditional expressions
(if_statement
  condition: (identifier) @condition_var.name) @conditional_usage

; 8. Variable in for loops
(for_statement
  left: (identifier) @loop_var.name
  right: (identifier) @iterable_var.name) @loop_usage