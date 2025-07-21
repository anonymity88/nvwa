module {
  // Define the mesh with a specific shape
  mesh.mesh @mesh0(shape = 2x2)

  // Define the main function
  func.func @main(%input : tensor<2x4xi8>) -> tensor<2x2xi8> {
    // Perform the mesh all_slice operation on the input tensor
    %result = mesh.all_slice %input on @mesh0 
                mesh_axes = [1] 
                slice_axis = 1 : tensor<2x4xi8> -> tensor<2x2xi8>

    // Return the result
    return %result : tensor<2x2xi8>
  }
}