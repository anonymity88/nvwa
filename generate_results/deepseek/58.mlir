module {
  // Function to create a tensor of type tensor<4xf32>
  func.func private @getTensor() -> tensor<4xf32> {
    %tensor = tensor.empty() : tensor<4xf32>
    return %tensor : tensor<4xf32>
  }

  // Function that processes the tensor
  func.func private @processTensor(%arg: tensor<4xf32>) -> () {
    return
  }

  // Main function combining all operations
  func.func @main(%a: i32, %b: i32, %flag: i1, %cond: i1) -> i32 {
    // First check the condition using an assert
    cf.assert %cond, "The condition was expected to be true, but it was false."
    
    // Execute tensor operations
    %0 = call @getTensor() : () -> tensor<4xf32>
    cf.br ^bb1(%0 : tensor<4xf32>)
  
  ^bb1(%arg0: tensor<4xf32>):
    call @processTensor(%arg0) : (tensor<4xf32>) -> ()
    
    // Based on the flag, perform conditional branching
    cf.cond_br %flag, ^bb2(%a : i32), ^bb3(%b : i32)
  
  ^bb2(%x: i32):
    return %x : i32
  
  ^bb3(%y: i32):
    return %y : i32
  }
}