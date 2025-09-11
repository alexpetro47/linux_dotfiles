; Class definitions
(class_definition
  name: (identifier) @class.name
  superclasses: (argument_list)? @class.parents
  body: (block) @class.body) @class.def

; Class instantiation
(call
  function: (identifier) @class_instantiation.name
  arguments: (argument_list) @class_instantiation.args) @class_instantiation

; Inheritance patterns
(class_definition
  superclasses: (argument_list
    (identifier) @parent_class.name)) @inheritance

; Method definitions within classes
(class_definition
  body: (block
    (function_definition
      name: (identifier) @class_method.name
      parameters: (parameters) @class_method.params) @class_method.def))

; Constructor method
(class_definition
  body: (block
    (function_definition
      name: (identifier) @constructor.name
      parameters: (parameters) @constructor.params) @constructor.def))
  (#eq? @constructor.name "__init__")

; Static and class methods
(class_definition
  body: (block
    (decorated_definition
      decorator: (decorator
        (identifier) @decorator.name) @decorator
      definition: (function_definition
        name: (identifier) @decorated_method.name
        parameters: (parameters) @decorated_method.params) @decorated_method.def)))
  (#any-of? @decorator.name "staticmethod" "classmethod")

; === ENHANCED CLASS ANALYSIS ===

; 1. Class method relationships - all methods within a class
(class_definition
  name: (identifier) @class_with_methods.name
  body: (block
    (function_definition
      name: (identifier) @class_method_rel.method
      parameters: (parameters) @class_method_rel.params) @class_method_rel.def)) @class_with_methods.def

; 2. Class attribute assignments (self.attr = value)
(class_definition
  body: (block
    (function_definition
      body: (block
        (expression_statement
          (assignment
            left: (attribute
              object: (identifier) @class_attr_assign.object
              attribute: (identifier) @class_attr_assign.name)
            right: (_) @class_attr_assign.value) @class_attr_assign.assignment)))))
  (#eq? @class_attr_assign.object "self")

; 3. Class attribute access (self.attr usage)
(class_definition
  body: (block
    (function_definition
      body: (block
        (expression_statement
          (attribute
            object: (identifier) @class_attr_access.object
            attribute: (identifier) @class_attr_access.name) @class_attr_access.usage)))))
  (#eq? @class_attr_access.object "self")

; 4. Class variable declarations (at class level)
(class_definition
  body: (block
    (expression_statement
      (assignment
        left: (identifier) @class_var.name
        right: (_) @class_var.value) @class_var.assignment)))

; 5. Method calling other class methods
(class_definition
  body: (block
    (function_definition
      name: (identifier) @caller_method.name
      body: (block
        (expression_statement
          (call
            function: (attribute
              object: (identifier) @method_to_method.object
              attribute: (identifier) @method_to_method.target)
            arguments: (argument_list) @method_to_method.args) @method_to_method.call)))))
  (#eq? @method_to_method.object "self")