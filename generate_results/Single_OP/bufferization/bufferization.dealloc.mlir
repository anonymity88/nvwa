module {
  func.func @main(%a0: memref<2xf32>, %a1: memref<4xi32>, %cond0: i1, %cond1: i1, %r0: memref<?xf32>, %r1: memref<f64>, %r2: memref<2xi32>) -> (i1, i1, i1) {
    // Deallocate the memrefs if their respective conditions are true and no aliases are retained
    %0:3 = bufferization.dealloc (%a0, %a1 : memref<2xf32>, memref<4xi32>)
                if (%cond0, %cond1) 
                retain (%r0, %r1, %r2 : memref<?xf32>, memref<f64>, memref<2xi32>)

    return %0#0, %0#1, %0#2 : i1, i1, i1
  }
}