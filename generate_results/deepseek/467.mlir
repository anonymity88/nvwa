module {
  func.func @combined_conversions(
    %arg0: index,
    %arg1: index
  ) -> (index, index, index) {
    // Call matching operands function
    %matched:2 = call @matchingOperands(%arg0, %arg1) : (index, index) -> (index, index)
    
    // Call empty cast function
    %empty = call @emptyCast() : () -> index
    
    return %matched#0, %matched#1, %empty : index, index, index
  }

  func.func @matchingOperands(%arg0: index, %arg1: index) -> (index, index) {
    %0:2 = builtin.unrealized_conversion_cast %arg0, %arg1 : index, index to i64, i64
    %1:3 = builtin.unrealized_conversion_cast %0#0, %0#1 : i64, i64 to i32, i32, i32
    %2:2 = builtin.unrealized_conversion_cast %1#0, %1#1, %1#2 : i32, i32, i32 to index, index
    return %2#0, %2#1 : index, index
  }

  func.func @emptyCast() -> index {
    %0 = builtin.unrealized_conversion_cast to index
    return %0 : index
  }
}