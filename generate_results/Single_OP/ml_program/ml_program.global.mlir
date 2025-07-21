module {
  // Constant global with a specific initial value and public visibility
  ml_program.global public @constant_var(dense<10> : tensor<4xi32>) : tensor<?xi32>

  // Mutable global variable with an initial external value and public visibility
  ml_program.global public mutable @external_var(#ml_program.extern<tensor<4xi32>>) : tensor<?xi32>

  // Mutable global variable with an undefined initial value and public visibility
  ml_program.global public mutable @undefined_var : tensor<?xi32>
  
  func.func @main() {
    // Example use of the globals would go here
    // Potentially loading/storing operations on these global variables
    return
  }
}