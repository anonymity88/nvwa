module {
  // Private and firstprivate recipes
  acc.private.recipe @privatization_memref_10_f32 : memref<10xf32> init {
    ^bb0(%arg0: memref<10xf32>):
      %0 = memref.alloc() : memref<10xf32>
      acc.yield %0 : memref<10xf32>
  } destroy {
    ^bb0(%arg0: memref<10xf32>):
      memref.dealloc %arg0 : memref<10xf32> 
      acc.terminator
  }

  acc.private.recipe @privatization_memref_10_10_f32 : memref<10x10xf32> init {
    ^bb0(%arg0: memref<10x10xf32>):
      %0 = memref.alloc() : memref<10x10xf32>
      acc.yield %0 : memref<10x10xf32>
  } destroy {
    ^bb0(%arg0: memref<10x10xf32>):
      memref.dealloc %arg0 : memref<10x10xf32> 
      acc.terminator
  }

  acc.firstprivate.recipe @firstprivatization_memref_20xf32 : memref<20xf32> init {
    ^bb0(%arg0: memref<20xf32>):
      %0 = memref.alloc() : memref<20xf32>
      acc.yield %0 : memref<20xf32>
  } copy {
    ^bb0(%arg0: memref<20xf32>, %arg1: memref<20xf32>):
      acc.terminator
  }

  acc.firstprivate.recipe @firstprivatization_memref_10xf32 : memref<10xf32> init {
    ^bb0(%arg0: memref<10xf32>):
      %0 = memref.alloc() : memref<10xf32>
      acc.yield %0 : memref<10xf32>
  } copy {
    ^bb0(%arg0: memref<10xf32>, %arg1: memref<10xf32>):
      acc.terminator
  } destroy {
    ^bb0(%arg0: memref<10xf32>):
      memref.dealloc %arg0 : memref<10xf32> 
      acc.terminator
  }

  // Main function that calls all operations
  func.func @main(%a: memref<10xf32>, %b: memref<10xf32>, %c: memref<10x10xf32>, %x: memref<i32>) {
    // Call testserialop with memrefs
    call @testserialop(%a, %b, %c) : (memref<10xf32>, memref<10xf32>, memref<10x10xf32>) -> ()
    
    // Call update_no_op with memref
    call @update_no_op(%x) : (memref<i32>) -> ()
    
    return
  }

  // Function with serial operations
  func.func @testserialop(%a: memref<10xf32>, %b: memref<10xf32>, %c: memref<10x10xf32>) -> () {
    %i64value = arith.constant 1 : i64
    %i32value = arith.constant 1 : i32
    %idxValue = arith.constant 1 : index
    
    // Various serial operations with different attributes
    acc.serial async(%i64value: i64) {
      acc.yield
    }
    
    acc.serial async(%i32value: i32) {
      acc.yield
    }
    
    acc.serial async(%idxValue: index) {
      acc.yield
    }
    
    acc.serial wait({%i64value: i64}) {
      acc.yield
    }
    
    acc.serial wait({%i32value: i32}) {
      acc.yield
    }
    
    acc.serial wait({%idxValue: index}) {
      acc.yield
    }
    
    acc.serial wait({%i64value : i64, %i32value : i32, %idxValue : index}) {
      acc.yield
    }
    
    %firstprivate = acc.firstprivate varPtr(%b : memref<10xf32>) -> memref<10xf32>
    
    acc.serial private(@privatization_memref_10_f32 -> %a : memref<10xf32>, 
                      @privatization_memref_10_10_f32 -> %c : memref<10x10xf32>) 
            firstprivate(@firstprivatization_memref_10xf32 -> %firstprivate : memref<10xf32>) {
      acc.yield
    }
    
    acc.serial {
      acc.yield
    } attributes {defaultAttr = #acc<defaultvalue none>}
    
    acc.serial {
      acc.yield
    } attributes {defaultAttr = #acc<defaultvalue present>}
    
    acc.serial {
      acc.yield
    } attributes {asyncAttr}
    
    acc.serial {
      acc.yield
    } attributes {waitAttr}
    
    acc.serial {
      acc.yield
    } attributes {selfAttr}
    
    acc.serial {
      acc.yield
    } attributes {selfAttr}
    
    return
  }

  // Atomic update function
  func.func @update_no_op(%x : memref<i32>) {
    acc.atomic.update %x : memref<i32> {
    ^bb0(%xval : i32):
      acc.yield %xval : i32
    }
    return
  }
}