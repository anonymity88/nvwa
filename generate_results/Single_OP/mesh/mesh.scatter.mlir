module {
  // Define the mesh with a specific shape
  mesh.mesh @mesh0(shape = 2x2)

  // Define the main function
  func.func @main(%input : tensor<2x2xi8>) -> tensor<1x2xi8> {
    // Perform the mesh scatter operation on the input tensor
    %result = mesh.scatter %input on @mesh0 
                     mesh_axes = [0] 
                     scatter_axis = 0 
                     root = [1] : (tensor<2x2xi8>) -> tensor<1x2xi8>
    
    // Return the result
    return %result : tensor<1x2xi8>
  }
}