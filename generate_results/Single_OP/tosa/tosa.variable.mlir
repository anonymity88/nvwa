module {
  func.func @main() -> tensor<4xf32> {
    // Define a TOSA variable
    "tosa.variable"() {name = "my_var", type = tensor<4xf32>, initial_value = dense<[1.0, 2.0, 3.0, 4.0]> : tensor<4xf32>} : () -> ()

    // Read the value from the variable
    %val_read = "tosa.variable.read"() {name = "my_var"} : () -> tensor<4xf32>

    // Perform some operations on the read value
    %result = "tosa.mul"(%val_read, %val_read) {shift = 0 : i8} : (tensor<4xf32>, tensor<4xf32>) -> tensor<4xf32>

    // Write the result back to the variable
    "tosa.variable.write"(%result) {name = "my_var"} : (tensor<4xf32>) -> ()

    // Return the final value read from the variable
    %final_val = "tosa.variable.read"() {name = "my_var"} : () -> tensor<4xf32>
    return %final_val : tensor<4xf32>
  }
}