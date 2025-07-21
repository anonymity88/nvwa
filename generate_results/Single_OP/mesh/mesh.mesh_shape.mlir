module {
  // Define a mesh with a specific shape
  mesh.mesh @mesh0(shape = 3x4x5)

  // Define the main function
  func.func @main() -> (index, index, index) {
    // Perform the mesh.mesh_shape operation to retrieve the shape of the mesh
    %d0, %d1, %d2 = mesh.mesh_shape @mesh0 : index, index, index

    // Return the shape
    return %d0, %d1, %d2 : index, index, index
  }
}