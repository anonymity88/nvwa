module {
  func.func @main(%a: index, %b: i64) -> (i32, index) {
    // Cast the index type to i32
    %int32_value = index.castu %a : index to i32
    
    // Cast the i64 type to index
    %index_value = index.castu %b : i64 to index
    
    return %int32_value, %index_value : i32, index
  }
}