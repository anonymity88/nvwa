#map0 = affine_map<()[s0] -> (s0 floordiv 50176)>
#map1 = affine_map<()[s0] -> ((s0 mod 50176) floordiv 224)>
#map2 = affine_map<()[s0] -> (s0 mod 224)>
#map10 = affine_map<(d0, d1) -> (d0 floordiv 8 + d1 floordiv 128)>
#map20 = affine_map<(i)[s0] -> (i + s0)>

module {
  func.func @main() -> () {
    %linear_index = arith.constant 100000 : index
    %c16 = arith.constant 16 : index
    %c224 = arith.constant 224 : index
    %s = arith.constant 64 : index
    %t = arith.constant 256 : index
    %n = arith.constant 10 : index
    %42 = arith.constant 42 : index

    %indices:3 = affine.delinearize_index %linear_index into (%c16, %c224, %c224) : index, index, index

    %result1 = affine.apply #map10(%s, %t)
    %result2 = affine.apply #map20(%42)[%n]

    affine.for %i = 0 to 10 {
      %buffer = memref.alloca() : memref<10xi32>
      %value = arith.constant 42 : i32
      affine.store %value, %buffer[%i] : memref<10xi32>
      affine.yield
    }

    %sum_indices = arith.addi %indices#0, %indices#1 : index
    %total_sum = arith.addi %sum_indices, %indices#2 : index

    %combined_result = arith.addi %result1, %result2 : index

    // Call the affine_store function
    call @affine_store(%combined_result) : (index) -> ()

    return
  }

  func.func @affine_store(%arg0 : index) {
    %0 = memref.alloc() : memref<10xf32>
    %1 = arith.constant 11.0 : f32
    affine.for %i0 = 0 to 10 {
      affine.store %1, %0[%i0 - symbol(%arg0) + 7] : memref<10xf32>
    }
    return
  }
}