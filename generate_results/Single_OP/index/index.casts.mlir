module {
  func.func @main(%a: index, %b: i64) -> (i32, index) {
    // Cast from index to i32
    %0 = index.casts %a : index to i32
    
    // Cast from i64 to index
    %1 = index.casts %b : i64 to index

    return %0, %1 : i32, index
  }
}