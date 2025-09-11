; Function definitions
(function_definition
  name: (identifier) @function.name
  parameters: (parameters) @function.params
  return_type: (type)? @function.return_type
  body: (block) @function.body) @function.def

; Async function definitions  
(async_function_definition
  name: (identifier) @async_function.name
  parameters: (parameters) @async_function.params
  return_type: (type)? @async_function.return_type
  body: (block) @async_function.body) @async_function.def

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