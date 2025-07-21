module {
  // Define the mesh with a specific shape
  mesh.mesh @mesh0(shape = 10x20x30)

  // Define the main function
  func.func @main() -> index {
    // Perform the mesh.process_linear_index operation to get the linear index of the current device
    %idx = mesh.process_linear_index on @mesh0 : index

    // Return the index
    return %idx : index
  }
}