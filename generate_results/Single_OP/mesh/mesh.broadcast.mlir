module {
  // Define the mesh with a specific shape
  mesh.mesh @mesh0(shape = 2x2)

  // Define the main function
  func.func @main() -> tensor<2x2xi8> {
    // Define input tensor using a constant operation from the arith dialect with the correct shape
    %input = arith.constant dense<[[1, 2], [3, 4]]> : tensor<2x2xi8>
    
    // Perform the mesh broadcast operation on the input tensor
    %result = mesh.broadcast %input on @mesh0 
                      mesh_axes = [0] 
                      root = [0] : (tensor<2x2xi8>) -> tensor<2x2xi8>
    
    // Return the result
    return %result : tensor<2x2xi8>
  }
}