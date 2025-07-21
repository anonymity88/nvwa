module {
  // Define the mesh with a specific shape
  mesh.mesh @mesh0(shape = 3)

  // Define the main function
  func.func @main(%input : tensor<3x2xi8>) -> tensor<3x2xi8> {
    // Perform the mesh all-to-all operation on the input tensor
    %result = mesh.all_to_all %input on @mesh0 
                          mesh_axes = [0]
                          split_axis = 0 concat_axis = 0 
                          : tensor<3x2xi8> -> tensor<3x2xi8>
    
    // Return the result
    return %result : tensor<3x2xi8>
  }
}