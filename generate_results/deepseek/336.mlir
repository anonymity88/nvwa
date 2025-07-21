module {
  func.func private @getTensor() -> tensor<4xf32> {
    %tensor = tensor.empty() : tensor<4xf32>
    return %tensor : tensor<4xf32>
  }

  func.func private @processTensor(%arg: tensor<4xf32>) -> () {
    return
  }

  func.func @inconsistent_memory_space() -> tensor<5xf32> {
    %0 = bufferization.alloc_tensor() {memory_space = 0 : ui64} : tensor<5xf32>
    cf.br ^bb1(%0: tensor<5xf32>)
  ^bb1(%arg1: tensor<5xf32>):
    func.return %arg1 : tensor<5xf32>
  ^bb2():
    %1 = bufferization.alloc_tensor() {memory_space = 1 : ui64} : tensor<5xf32>
    cf.br ^bb1(%1: tensor<5xf32>)
  }

  func.func @cannot_infer_type() {
    return
  }

  func.func @main(%a: i32, %b: i32, %flag_i1: i1, %flag_i32: i32) -> (i32, tensor<5xf32>) {
    %0 = call @getTensor() : () -> tensor<4xf32>
    cf.br ^bb1(%0 : tensor<4xf32>)
  
  ^bb1(%arg0: tensor<4xf32>):
    call @processTensor(%arg0) : (tensor<4xf32>) -> ()
    
    cf.cond_br %flag_i1, ^bb2(%a : i32), ^bb3(%b : i32)
  
  ^bb2(%x: i32):
    cf.br ^bb4(%x : i32)
  
  ^bb3(%y: i32):
    cf.br ^bb4(%y : i32)
  
  ^bb4(%result: i32):
    %mem_tensor = call @inconsistent_memory_space() : () -> tensor<5xf32>
    call @cannot_infer_type() : () -> ()
    
    cf.switch %flag_i32 : i32, [
      default: ^bb7(%result : i32),
      0: ^bb5(%result : i32),
      1: ^bb6(%result : i32)
    ]
  
  ^bb5(%val1: i32):
    return %val1, %mem_tensor : i32, tensor<5xf32>
  
  ^bb6(%val2: i32):
    return %val2, %mem_tensor : i32, tensor<5xf32>
  
  ^bb7(%val3: i32):
    return %val3, %mem_tensor : i32, tensor<5xf32>
  }
}