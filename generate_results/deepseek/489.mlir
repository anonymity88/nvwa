module {
  // Define the private memory reference for privatization
  acc.private.recipe @privatization_memref_10_f32 : memref<10xf32> init {
    ^bb0(%arg0: memref<10xf32>):
      %0 = memref.alloc() : memref<10xf32>
      acc.yield %0 : memref<10xf32>
  } destroy {
    ^bb0(%arg0: memref<10xf32>):
      memref.dealloc %arg0 : memref<10xf32> 
      acc.terminator
  }

  // Main function that combines all operations
  func.func @main(%a: memref<10xf32>, %b: memref<f32>, %c: memref<f32>, %d: memref<f32>) -> () {
    // Call test function with memref<10xf32>
    call @test(%a) : (memref<10xf32>) -> ()
    
    // Call testupdateop function with memref<f32> arguments
    call @testupdateop(%b, %c, %d) : (memref<f32>, memref<f32>, memref<f32>) -> ()
    
    return
  }

  // Function with parallel loop and private memory
  func.func @test(%a: memref<10xf32>) {
    %lb = arith.constant 0 : index
    %st = arith.constant 1 : index
    %c10 = arith.constant 10 : index
    %p1 = acc.private varPtr(%a : memref<10xf32>) -> memref<10xf32>
    acc.parallel {
      acc.loop private(@privatization_memref_10_f32 -> %p1 : memref<10xf32>) control(%i : index) = (%lb : index) to (%c10 : index) step (%st : index) {
        %ci = memref.load %a[%i] : memref<10xf32>
        acc.yield
      }
      acc.yield
    }
    return
  }

  // Function with various update operations
  func.func @testupdateop(%a: memref<f32>, %b: memref<f32>, %c: memref<f32>) -> () {
    %i64Value = arith.constant 1 : i64
    %i32Value = arith.constant 1 : i32
    %idxValue = arith.constant 1 : index
    %ifCond = arith.constant true
    
    // Create device pointers
    %0 = acc.update_device varPtr(%a : memref<f32>) -> memref<f32>
    %1 = acc.update_device varPtr(%b : memref<f32>) -> memref<f32>
    %2 = acc.update_device varPtr(%c : memref<f32>) -> memref<f32>
    
    // Various update operations
    acc.update async(%i64Value: i64) dataOperands(%0: memref<f32>)
    acc.update async(%i32Value: i32) dataOperands(%0: memref<f32>)
    acc.update async(%i32Value: i32) dataOperands(%0: memref<f32>)
    acc.update async(%idxValue: index) dataOperands(%0: memref<f32>)
    acc.update wait({devnum: %i64Value: i64, %i32Value : i32, %idxValue : index}) dataOperands(%0: memref<f32>)
    acc.update if(%ifCond) dataOperands(%0: memref<f32>)
    acc.update dataOperands(%0: memref<f32>)
    acc.update dataOperands(%0, %1, %2 : memref<f32>, memref<f32>, memref<f32>)
    acc.update async dataOperands(%0, %1, %2 : memref<f32>, memref<f32>, memref<f32>)
    acc.update wait dataOperands(%0, %1, %2 : memref<f32>, memref<f32>, memref<f32>)
    acc.update dataOperands(%0, %1, %2 : memref<f32>, memref<f32>, memref<f32>) attributes {ifPresent}
    
    return
  }
}