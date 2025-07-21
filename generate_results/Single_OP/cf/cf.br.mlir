module {
  // Declare the external functions to resolve reference errors.
  func.func private @getTensor() -> tensor<4xf32>
  func.func private @processTensor(%arg: tensor<4xf32>) -> ()

  func.func @main() -> () {
    // Define the first block.
    ^bb1:
      // Call a function that returns some tensor.
      %0 = call @getTensor() : () -> tensor<4xf32>
      // Unconditional branch to the second block, passing the tensor.
      cf.br ^bb2(%0 : tensor<4xf32>)

    // Define the second block with a single argument.
    ^bb2(%arg0: tensor<4xf32>):
      // The second block can use the tensor passed from the first block.
      call @processTensor(%arg0) : (tensor<4xf32>) -> ()
      // Add a return terminator operation for the block.
      return
  }
}