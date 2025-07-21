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
  func.func @main(%a: i32, %b: i32, %flag_i1: i1, %flag_i32: i32) -> i32 {
    // First handle tensor operations
    %0 = call @getTensor() : () -> tensor<4xf32>
    cf.br ^bb1(%0 : tensor<4xf32>)

  ^bb1(%arg0: tensor<4xf32>):
    call @processTensor(%arg0) : (tensor<4xf32>) -> ()
    
    // Handle the i1 flag conditional branch
    cf.cond_br %flag_i1, ^bb2(%a : i32), ^bb3(%b : i32)

  ^bb2(%x: i32):
    // Handle the i32 flag switch statement
    cf.switch %flag_i32 : i32, [
      default: ^bb6(%x : i32),
      0: ^bb4(%x : i32),
      1: ^bb5(%b : i32)
    ]

  ^bb3(%y: i32):
    // Handle the i32 flag switch statement
    cf.switch %flag_i32 : i32, [
      default: ^bb6(%y : i32),
      0: ^bb4(%a : i32),
      1: ^bb5(%y : i32)
    ]

  ^bb4(%val1: i32):
    return %val1 : i32

  ^bb5(%val2: i32):
    return %val2 : i32

  ^bb6(%val3: i32):
    return %val3 : i32
  }
}