module {
  func.func private @getTensor() -> tensor<4xf32> {
    %tensor = tensor.empty() : tensor<4xf32>
    return %tensor : tensor<4xf32>
  }

  func.func private @processTensor(%arg: tensor<4xf32>) -> () {
    return
  }

  func.func @condBranchDynamicType(
    %arg0: i1,
    %arg1: memref<?xf32>,
    %arg2: memref<?xf32>,
    %arg3: index) {
    cf.cond_br %arg0, ^bb1, ^bb2(%arg3: index)
  ^bb1:
    cf.br ^bb3(%arg1 : memref<?xf32>)
  ^bb2(%0: index):
    %1 = memref.alloc(%0) : memref<?xf32>
    test.buffer_based in(%arg1: memref<?xf32>) out(%1: memref<?xf32>)
    cf.br ^bb3(%1 : memref<?xf32>)
  ^bb3(%2: memref<?xf32>):
    test.copy(%2, %arg2) : (memref<?xf32>, memref<?xf32>)
    return
  }

  func.func @main(%a: i32, %b: i32, %flag: i1, %cond: i1, 
                  %dynamic_cond: i1, %mem1: memref<?xf32>, 
                  %mem2: memref<?xf32>, %size: index) -> i32 {
    cf.assert %cond, "The condition was expected to be true, but it was false."
    
    %0 = call @getTensor() : () -> tensor<4xf32>
    cf.br ^bb1(%0 : tensor<4xf32>)
  
  ^bb1(%arg0: tensor<4xf32>):
    call @processTensor(%arg0) : (tensor<4xf32>) -> ()
    call @condBranchDynamicType(%dynamic_cond, %mem1, %mem2, %size) : 
         (i1, memref<?xf32>, memref<?xf32>, index) -> ()
    
    cf.cond_br %flag, ^bb2(%a : i32), ^bb3(%b : i32)
  
  ^bb2(%x: i32):
    return %x : i32
  
  ^bb3(%y: i32):
    return %y : i32
  }
}