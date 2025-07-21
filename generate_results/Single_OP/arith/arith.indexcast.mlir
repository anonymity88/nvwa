module {
  // Define an affine map if necessary (this section can contain affine_map definitions)
  // For this example, no specific affine maps are needed.

  func.func @example_function(%input: i32) -> index {
    // The following line uses the arith.indexcast to convert an i32 to an index type
    %result = arith.index_cast %input : i32 to index
    return %result : index
  }
}