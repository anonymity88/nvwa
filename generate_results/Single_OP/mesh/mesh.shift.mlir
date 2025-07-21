module {
  // Define the mesh with a specific shape
  mesh.mesh @mesh0(shape = 2x4)

  // Define the main function
  func.func @main() -> tensor<2x4xi8> {
    // Define input tensor using a constant operation from the arith dialect
    %input = arith.constant dense<[[1, 2, 3, 4], [5, 6, 7, 8]]> : tensor<2x4xi8>
    
    // Perform the mesh shift operation on the input tensor
    %result = mesh.shift %input on @mesh0 mesh_axes = [1] 
                      shift_axis = 1 offset = 2 rotate : tensor<2x4xi8> -> tensor<2x4xi8>
    
    // Return the result
    return %result : tensor<2x4xi8>
  }
}