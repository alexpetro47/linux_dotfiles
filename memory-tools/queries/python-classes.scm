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