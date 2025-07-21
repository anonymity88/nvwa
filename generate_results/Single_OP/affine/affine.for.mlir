#map_lower = affine_map<(d0) -> (d0)>
#map_upper = affine_map<(d0) -> (d0)>

module {
  func.func @main() -> (f32) {
    // Allocate input buffer
    %buffer = memref.alloca() : memref<1024xf32>
    
    // Initialize constant for upper bound
    %c10 = arith.constant 10 : index

    // Initialize sum
    %sum_0 = arith.constant 0.0 : f32

    // Loop from 0 to 10 with initial sum variable
    affine.for %i = 0 to %c10 iter_args(%sum_iter = %sum_0) -> (f32) {
      // Load value from buffer
      %t = affine.load %buffer[%i] : memref<1024xf32>
      
      // Add to sum
      %sum_next = arith.addf %sum_iter, %t : f32
      
      // Yield the current sum
      affine.yield %sum_next : f32
    }
    
    return %sum_0 : f32
  }
}