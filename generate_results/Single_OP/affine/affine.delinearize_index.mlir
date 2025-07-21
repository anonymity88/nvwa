#map0 = affine_map<()[s0] -> (s0 floordiv 50176)>
#map1 = affine_map<()[s0] -> ((s0 mod 50176) floordiv 224)>
#map2 = affine_map<()[s0] -> (s0 mod 224)>

module {
  func.func @main() -> () {
    // Allocate a linear index variable
    %linear_index = arith.constant 100000 : index
    
    // The basis for the delinearization
    %c16 = arith.constant 16 : index
    %c224 = arith.constant 224 : index
    
    // Delinearize the index into multiple indices
    %indices:3 = affine.delinearize_index %linear_index into (%c16, %c224, %c224) : index, index, index

    return
  }
}