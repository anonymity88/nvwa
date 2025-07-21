module {
  func.func @get_bool_const() -> i1 {
    %bool_const = index.bool.constant true
    return %bool_const : i1
  }

  func.func @compute_min(%a: index, %b: index) -> index {
    %min_value = index.mins %a, %b
    return %min_value : index
  }

  func.func @compute_and(%a: index, %b: index) -> index {
    %result = index.and %a, %b
    return %result : index
  }

  func.func @index_cast_to(%a: i32, %b: i64) -> (index, index, index, index) {
    %0 = index.casts %a : i32 to index
    %1 = index.casts %b : i64 to index
    %2 = index.castu %a : i32 to index
    %3 = index.castu %b : i64 to index
    return %0, %1, %2, %3 : index, index, index, index
  }

  func.func @main(%a: index, %b: index, %c: i32, %d: i64) -> (index, index, i1, index, index, index, index) {
    %bool_val = call @get_bool_const() : () -> i1
    
    %min_result = call @compute_min(%a, %b) : (index, index) -> index
    
    %and_result = call @compute_and(%a, %b) : (index, index) -> index

    %cast_results:4 = call @index_cast_to(%c, %d) : (i32, i64) -> (index, index, index, index)
    
    return %min_result, %and_result, %bool_val, %cast_results#0, %cast_results#1, %cast_results#2, %cast_results#3 : index, index, i1, index, index, index, index
  }
}