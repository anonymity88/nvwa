module {
  func.func @get_size() -> index {
    %size_in_bits = index.sizeof
    return %size_in_bits : index
  }

  func.func @divide_indices(%a: index, %b: index) -> index {
    %result = index.divu %a, %b
    return %result : index
  }

  func.func @index_constant() {
    %0 = index.constant -2100000000
    %1 = index.constant 2100000000
    %2 = index.constant -3000000000
    %3 = index.constant 3000000000
    return
  }

  func.func @main(%a: index, %b: i64) -> (i32, index, index) {
    %cast_to_i32 = index.casts %a : index to i32
    
    %cast_to_index = index.casts %b : i64 to index

    %size = call @get_size() : () -> index

    %divided = call @divide_indices(%cast_to_index, %size) : (index, index) -> index

    // Call index_constant function
    call @index_constant() : () -> ()

    return %cast_to_i32, %cast_to_index, %divided : i32, index, index
  }
}