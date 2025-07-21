module {
  func.func @main(%a: index, %b: index) -> index {
    // First compute the remainder (unsigned)
    %remainder = "index.remu"(%a, %b) : (index, index) -> index
    
    // Then perform a left shift on the original inputs
    %shift_left = "index.shl"(%a, %b) : (index, index) -> index
    
    // Then perform a right shift (signed) on the shifted value
    %shift_right = "index.shrs"(%shift_left, %b) : (index, index) -> index
    
    // Return the final shifted value
    return %shift_right : index
  }
}