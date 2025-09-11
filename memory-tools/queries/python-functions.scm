; Function definitions
(function_definition
  name: (identifier) @function.name
  parameters: (parameters) @function.params
  return_type: (type)? @function.return_type
  body: (block) @function.body) @function.def

; Async function definitions (tree-sitter-python doesn't have async_function_definition)
; Use function_definition and check for async in decorators or context

; Method definitions (functions inside classes)
(class_definition
  body: (block
    (function_definition
      name: (identifier) @method.name
      parameters: (parameters) @method.params
      return_type: (type)? @method.return_type
      body: (block) @method.body) @method.def))

; Function calls
(call
  function: (identifier) @function_call.name
  arguments: (argument_list) @function_call.args) @function_call

; Method calls
(call
  function: (attribute
    object: (identifier) @method_call.object
    attribute: (identifier) @method_call.method)
  arguments: (argument_list) @method_call.args) @method_call

; === ENHANCED ANALYSIS QUERIES ===

; 1. Internal function calls (same file)
(call
  function: (identifier) @internal_call.name
  arguments: (argument_list) @internal_call.args) @internal_call

; 2. Nested function definitions
(function_definition
  body: (block
    (function_definition
      name: (identifier) @nested_function.name
      parameters: (parameters) @nested_function.params
      body: (block) @nested_function.body) @nested_function.def)) @nested_scope

; 3. Method calls within functions (internal method usage)
(function_definition
  body: (block
    (expression_statement
      (call
        function: (identifier) @internal_method_call.name
        arguments: (argument_list) @internal_method_call.args) @internal_method_call)))

; 4. Self method calls (method calling other methods)
(call
  function: (attribute
    object: (identifier) @self_call.object
    attribute: (identifier) @self_call.method)
  arguments: (argument_list) @self_call.args) @self_call
  (#eq? @self_call.object "self")