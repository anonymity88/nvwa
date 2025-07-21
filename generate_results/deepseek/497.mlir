module {
  // Define the private memory reference for privatization (only once)
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
  func.func @main(%a1: memref<10xf32>, %a2: memref<10x10xf32>, %b: memref<10x10xf32>, %c: memref<10xf32>, %d: memref<10xf32>) -> memref<10xf32> {
    // Call test function with 1D memref
    call @test(%a1) : (memref<10xf32>) -> ()
    
    // Call compute3 function with 2D memrefs
    %result = call @compute3(%a2, %b, %c, %d) : (memref<10x10xf32>, memref<10x10xf32>, memref<10xf32>, memref<10xf32>) -> memref<10xf32>
    
    return %result : memref<10xf32>
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

  // Compute function with parallel operations
  func.func @compute3(%a: memref<10x10xf32>, %b: memref<10x10xf32>, %c: memref<10xf32>, %d: memref<10xf32>) -> memref<10xf32> {
    %lb = arith.constant 0 : index
    %st = arith.constant 1 : index
    %c10 = arith.constant 10 : index
    %numGangs = arith.constant 10 : i64
    %numWorkers = arith.constant 10 : i64
    %pa = acc.present varPtr(%a : memref<10x10xf32>) -> memref<10x10xf32>
    %pb = acc.present varPtr(%b : memref<10x10xf32>) -> memref<10x10xf32>
    %pc = acc.present varPtr(%c : memref<10xf32>) -> memref<10xf32>
    %pd = acc.present varPtr(%d : memref<10xf32>) -> memref<10xf32>
    acc.data dataOperands(%pa, %pb, %pc, %pd: memref<10x10xf32>, memref<10x10xf32>, memref<10xf32>, memref<10xf32>) {
      %private = acc.private varPtr(%c : memref<10xf32>) -> memref<10xf32>
      acc.parallel num_gangs({%numGangs: i64}) num_workers(%numWorkers: i64 [#acc.device_type<nvidia>]) private(@privatization_memref_10_f32 -> %private : memref<10xf32>) {
        acc.loop gang control(%x : index) = (%lb : index) to (%c10 : index) step (%st : index) {
          acc.loop worker control(%y : index) = (%lb : index) to (%c10 : index) step (%st : index) {
            %axy = memref.load %a[%x, %y] : memref<10x10xf32>
            %bxy = memref.load %b[%x, %y] : memref<10x10xf32>
            %tmp = arith.addf %axy, %bxy : f32
            memref.store %tmp, %c[%y] : memref<10xf32>
            acc.yield
          } attributes {inclusiveUpperbound = array<i1: true>}
          acc.loop control(%i : index) = (%lb : index) to (%c10 : index) step (%st : index) {
            %ci = memref.load %c[%i] : memref<10xf32>
            %dx = memref.load %d[%x] : memref<10xf32>
            %z = arith.addf %ci, %dx : f32
            memref.store %z, %d[%x] : memref<10xf32>
            acc.yield
          } attributes {inclusiveUpperbound = array<i1: true>, seq = [#acc.device_type<nvidia>]}
          acc.yield
        } attributes {inclusiveUpperbound = array<i1: true>}
        acc.yield
      }
      acc.terminator
    }
    return %d : memref<10xf32>
  }
}