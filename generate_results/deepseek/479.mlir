module {
  func.func @combined_conversion_operations(
    %arg0: index,
    %arg1: index,
    %cast_arg: i64
  ) -> (index, index, i32) {
    // Call swapping operands function
    %swapped:2 = call @swappingOperands(%arg0, %arg1) : (index, index) -> (index, index)
    
    // Call single cast function
    %cast_result = call @liveSingleCast(%cast_arg) : (i64) -> i32
    
    return %swapped#0, %swapped#1, %cast_result : index, index, i32
  }

  func.func @swappingOperands(%arg0: index, %arg1: index) -> (index, index) {
    %0:2 = builtin.unrealized_conversion_cast %arg0, %arg1 : index, index to i64, i64
    %1:2 = builtin.unrealized_conversion_cast %0#1, %0#0 : i64, i64 to i32, i32
    %2:2 = builtin.unrealized_conversion_cast %1#0, %1#1 : i32, i32 to index, index
    return %2#0, %2#1 : index, index
  }

  func.func @liveSingleCast(%arg0: i64) -> i32 {
    %0 = builtin.unrealized_conversion_cast %arg0 : i64 to i32
    return %0 : i32
  }
}