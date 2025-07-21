module {
  // Main function that demonstrates data flow between operations
  func.func @main(%a: memref<f32>, %ifCond: i1, %A: memref<10x10xf32>, %B: memref<10x10xf32>, %C: memref<10x10xf32>) -> memref<10x10xf32> {
    // First perform host data operation
    call @testhostdataop(%a, %ifCond) : (memref<f32>, i1) -> ()
    
    // Then perform matrix computation
    %result = call @compute2(%A, %B, %C) : (memref<10x10xf32>, memref<10x10xf32>, memref<10x10xf32>) -> memref<10x10xf32>
    
    return %result : memref<10x10xf32>
  }

  // Host data operation function
  func.func @testhostdataop(%a: memref<f32>, %ifCond: i1) -> () {
    %0 = acc.use_device varPtr(%a : memref<f32>) -> memref<f32>
    %true = arith.constant true
    acc.host_data dataOperands(%0 : memref<f32>) if(%true) {
      acc.terminator
    }
    return
  }

  // Matrix computation function
  func.func @compute2(%A: memref<10x10xf32>, %B: memref<10x10xf32>, %C: memref<10x10xf32>) -> memref<10x10xf32> {
    %c0 = arith.constant 0 : index
    %c10 = arith.constant 10 : index
    %c1 = arith.constant 1 : index
    acc.parallel {
      acc.loop control(%arg3 : index) = (%c0 : index) to (%c10 : index) step (%c1 : index) {
        scf.for %arg4 = %c0 to %c10 step %c1 {
          scf.for %arg5 = %c0 to %c10 step %c1 {
            %a = memref.load %A[%arg3, %arg5] : memref<10x10xf32>
            %b = memref.load %B[%arg5, %arg4] : memref<10x10xf32>
            %cij = memref.load %C[%arg3, %arg4] : memref<10x10xf32>
            %p = arith.mulf %a, %b : f32
            %co = arith.addf %cij, %p : f32
            memref.store %co, %C[%arg3, %arg4] : memref<10x10xf32>
          }
        }
        acc.yield
      } attributes {seq = [#acc.device_type<none>], inclusiveUpperbound = array<i1: true>}
      acc.yield
    }
    return %C : memref<10x10xf32>
  }

  // Additional utility function that could be called from main
  func.func @utility_func(%val: memref<f32>) -> memref<f32> {
    %0 = acc.getdeviceptr varPtr(%val : memref<f32>) -> memref<f32>
    acc.update_host accPtr(%0 : memref<f32>) to varPtr(%val : memref<f32>)
    return %val : memref<f32>
  }
}