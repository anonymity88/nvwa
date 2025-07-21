module {
  func.func @tile_example() -> tensor<2x8xi32> {
    // Create a constant tensor of shape 2x4
    %input = "tosa.const"() <{value = dense<[[1, 2, 3, 4], [5, 6, 7, 8]]> : tensor<2x4xi32>}> : () -> tensor<2x4xi32>
    
    // Apply the tile operator to replicate input along specified dimensions
    %0 = tosa.tile %input {multiples = array<i64: 1, 2>} : (tensor<2x4xi32>) -> tensor<2x8xi32>
    
    // Create a constant tensor of the same shape as expected after tiling (2x8)
    %const = "tosa.const"() <{value = dense<[[10, 10, 10, 10, 10, 10, 10, 10], 
                                               [10, 10, 10, 10, 10, 10, 10, 10]]> : tensor<2x8xi32>}> : () -> tensor<2x8xi32>
    
    // Perform addition with the tiled output
    %1 = tosa.add %0, %const : (tensor<2x8xi32>, tensor<2x8xi32>) -> tensor<2x8xi32>
  
    // Return the final tensor
    return %1 : tensor<2x8xi32>
  }
}