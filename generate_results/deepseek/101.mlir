module {
  func.func @get_size() -> index {
    %size_in_bits = index.sizeof
    return %size_in_bits : index
  }

  func.func @divide_indices(%a: index, %b: index) -> index {
    %result = index.divu %a, %b
    return %result : index
  }

  func.func @main(%a: index, %b: i64) -> (i32, index, index) {
    // Cast index to i32
    %cast_to_i32 = index.casts %a : index to i32
    
    // Cast i64 to index
    %cast_to_index = index.casts %b : i64 to index

    // Get size in bits
    %size = call @get_size() : () -> index

    // Divide the casted index by the size
    %divided = call @divide_indices(%cast_to_index, %size) : (index, index) -> index

    // Return all results
    return %cast_to_i32, %cast_to_index, %divided : i32, index, index
  }
}