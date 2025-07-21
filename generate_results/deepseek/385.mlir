module {
  func.func @compute_minu(%a: index, %b: index) -> index {
    %min_val = "index.minu"(%a, %b) : (index, index) -> index
    return %min_val : index
  }

  func.func @compute_sub(%a: index, %b: index) -> index {
    %sub_val = "index.sub"(%a, %b) : (index, index) -> index
    return %sub_val : index
  }

  func.func @compute_or(%a: index, %b: index) -> index {
    %or_val = "index.or"(%a, %b) : (index, index) -> index
    return %or_val : index
  }

  func.func @cast_op(%a: index, %b: i32, %c: i64) {
    %0 = index.casts %a : index to i64
    %1 = index.casts %b : i32 to index
    %2 = index.casts %c : i64 to index
    %3 = index.castu %a : index to i64
    %4 = index.castu %b : i32 to index
    %5 = index.castu %c : i64 to index
    return
  }

  func.func @main(%a: index, %b: index) -> index {
    %min_result = call @compute_minu(%a, %b) : (index, index) -> index
    %sub_result = call @compute_sub(%a, %b) : (index, index) -> index
    %or_result = call @compute_or(%a, %b) : (index, index) -> index
    
    %final_or1 = "index.or"(%min_result, %sub_result) : (index, index) -> index
    %final_result = "index.or"(%final_or1, %or_result) : (index, index) -> index

    // Demonstrate calling cast_op with some dummy values
    %dummy_i32 = arith.constant 42 : i32
    %dummy_i64 = arith.constant 42 : i64
    call @cast_op(%a, %dummy_i32, %dummy_i64) : (index, i32, i64) -> ()
    
    return %final_result : index
  }
}