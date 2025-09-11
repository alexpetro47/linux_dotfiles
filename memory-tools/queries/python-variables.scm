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