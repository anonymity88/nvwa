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
  func.func @main(%a: memref<10xf32>, %ptr_a: !llvm.ptr, %ptr_b: !llvm.ptr, %ptr_c: !llvm.ptr) -> () {
    // Call test function with memref
    call @test(%a) : (memref<10xf32>) -> ()
    
    // Call testenterdataop function with pointers
    call @testenterdataop(%ptr_a, %ptr_b, %ptr_c) : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    
    return
  }

  // Function to test enter data operations
  func.func @testenterdataop(%a: !llvm.ptr, %b: !llvm.ptr, %c: !llvm.ptr) -> () {
    %ifCond = arith.constant true
    %i64Value = arith.constant 1 : i64
    %i32Value = arith.constant 1 : i32
    %idxValue = arith.constant 1 : index
    
    // Various enter data operations
    %0 = acc.copyin varPtr(%a : !llvm.ptr) -> !llvm.ptr
    acc.enter_data dataOperands(%0 : !llvm.ptr)
    
    %1 = acc.create varPtr(%a : !llvm.ptr) -> !llvm.ptr
    %2 = acc.create varPtr(%b : !llvm.ptr) -> !llvm.ptr {dataClause = #acc<data_clause acc_create_zero>}
    %3 = acc.create varPtr(%c : !llvm.ptr) -> !llvm.ptr {dataClause = #acc<data_clause acc_create_zero>}
    acc.enter_data dataOperands(%1, %2, %3 : !llvm.ptr, !llvm.ptr, !llvm.ptr)
    
    %4 = acc.attach varPtr(%a : !llvm.ptr) -> !llvm.ptr
    acc.enter_data dataOperands(%4 : !llvm.ptr)
    
    %5 = acc.copyin varPtr(%a : !llvm.ptr) -> !llvm.ptr
    acc.enter_data dataOperands(%5 : !llvm.ptr) attributes {async}
    
    %6 = acc.create varPtr(%a : !llvm.ptr) -> !llvm.ptr
    acc.enter_data dataOperands(%6 : !llvm.ptr) attributes {wait}
    
    %7 = acc.copyin varPtr(%a : !llvm.ptr) -> !llvm.ptr
    acc.enter_data async(%i64Value : i64) dataOperands(%7 : !llvm.ptr)
    
    %8 = acc.copyin varPtr(%a : !llvm.ptr) -> !llvm.ptr
    acc.enter_data dataOperands(%8 : !llvm.ptr) async(%i64Value : i64)
    
    %9 = acc.copyin varPtr(%a : !llvm.ptr) -> !llvm.ptr
    acc.enter_data if(%ifCond) dataOperands(%9 : !llvm.ptr)
    
    %10 = acc.copyin varPtr(%a : !llvm.ptr) -> !llvm.ptr
    acc.enter_data wait_devnum(%i64Value: i64) wait(%i32Value, %idxValue : i32, index) dataOperands(%10 : !llvm.ptr)
    
    return
  }

  // Function to test parallel loop with private memory
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
}