module {
  func.func @constant_op() -> (index, index, index) {
    %0 = "index.constant"() {value = 0 : index} : () -> index
    %1 = "index.constant"() {value = 1 : index} : () -> index
    %2 = "index.constant"() {value = 42 : index} : () -> index
    return %0, %1, %2 : index, index, index
  }

  func.func @main(%a: index, %b: index) -> index {
    // Call constant_op to get constants
    %zero, %one, %fortytwo = call @constant_op() : () -> (index, index, index)
    
    // Original operations from main
    %remainder = "index.remu"(%a, %b) : (index, index) -> index
    %shift_left = "index.shl"(%a, %b) : (index, index) -> index
    %shift_right = "index.shrs"(%shift_left, %b) : (index, index) -> index
    
    // Use one of the constants from constant_op
    %final_result = "index.add"(%shift_right, %fortytwo) : (index, index) -> index
    
    return %final_result : index
  }
}