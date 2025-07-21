module {
  // Define the global memref variable @foo
  memref.global @foo : memref<2xf32>

  func.func @main() -> () {
    // Get the memref pointing to the global variable @foo
    %global_memref = memref.get_global @foo : memref<2xf32>
    
    // The retrieved memref can now be used here, for example:
    // %value = memref.load %global_memref[0] : memref<2xf32>

    return
  }
}