#map = affine_map<(d0, d1) -> (d0 + d1)>
#set = affine_set<(d0, d1)[s0] : (d0 - 10 >= 0, s0 - d0 - 9 >= 0, 
                                  d1 - 10 >= 0, s0 - d1 - 9 >= 0)>

module {
  func.func @example_with_affine_if(%N: i32) -> () {
    %A = memref.alloca() : memref<10xi32>
    %X = arith.constant 42 : i32

    // Cast %N to index for the affine loop
    %N_index = arith.index_cast %N : i32 to index

    // Outer loop with an induction variable %i
    affine.for %i = 0 to %N_index {
      // Inner loop with an induction variable %j
      affine.for %j = 0 to %N_index {
        %tmp_result = func.call @S1(%X, %i, %j) : (i32, index, index) -> i32

        // Condition is defined by affine set #set and dimensions %i, %j with symbol %N_index
        affine.if #set(%i, %j)[%N_index] {
          %calculated_index = affine.apply #map(%i, %j)
          func.call @S2(%tmp_result, %A, %i, %calculated_index) : (i32, memref<10xi32>, index, index) -> ()
        }
      }
    }

    return
  }

  // Dummy function to emulate S1 and S2 calls
  func.func private @S1(%x: i32, %i: index, %j: index) -> i32 {
    %result = arith.addi %x, %x : i32
    return %result : i32
  }

  func.func private @S2(%tmp: i32, %a: memref<10xi32>, %i: index, %j: index) -> () {
    // Just a dummy body
    return
  }
}