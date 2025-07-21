module {
  // Define the device mesh with a specific shape
  mesh.mesh @mesh0(shape = 4x8x12)
  
  // Define another device mesh with unknown dimensions
  mesh.mesh @mesh1(shape = 4x?)
  
  // Define another device mesh with unknown first dimension
  mesh.mesh @mesh2(shape = ?x4)
  
  // Define another device mesh with both dimensions unknown
  mesh.mesh @mesh3(shape = ?x?)

  // Define the main function
  func.func @main() -> () {
    // The main function does not have output at this point
    return
  }
}