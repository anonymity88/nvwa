module {
  func.func @testexitdataop(%a: memref<f32>, %ifCond: i1) -> () {
    %0 = acc.getdeviceptr varPtr(%a : memref<f32>) -> memref<f32>
    acc.exit_data if(%ifCond) dataOperands(%0 : memref<f32>)
    acc.delete accPtr(%0 : memref<f32>)
    return
  }

  func.func @test(%a: memref<10xf32>, %i : index) {
    %create = acc.create varPtr(%a : memref<10xf32>) -> memref<10xf32>
    acc.parallel dataOperands(%create : memref<10xf32>) {
      %ci = memref.load %a[%i] : memref<10xf32>
      acc.yield
    }
    return
  }

  func.func @main() {
    // Create test data
    %a = memref.alloc() : memref<10xf32>
    %f = memref.alloc() : memref<f32>
    %i = arith.constant 0 : index
    %true = arith.constant true

    // Call test functions with proper data flow
    call @test(%a, %i) : (memref<10xf32>, index) -> ()
    call @testexitdataop(%f, %true) : (memref<f32>, i1) -> ()

    // Cleanup
    memref.dealloc %a : memref<10xf32>
    memref.dealloc %f : memref<f32>
    return
  }
}