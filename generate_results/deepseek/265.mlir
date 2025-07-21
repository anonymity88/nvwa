module {
  func.func @logical_operation(%arg0: i32, %arg1: i32) -> i1 {
    %0 = "emitc.logical_and"(%arg0, %arg1) : (i32, i32) -> i1
    return %0 : i1
  }

  func.func @bitwise_operation(%arg0: i32, %arg1: i32) -> i32 {
    %0 = "emitc.bitwise_xor"(%arg0, %arg1) : (i32, i32) -> i32
    return %0 : i32
  }

  func.func @array_operation(%arg0: !emitc.array<4x8xf32>, %arg1: !emitc.ptr<i32>, %i: index, %j: index) -> () {
    %0 = "emitc.subscript"(%arg0, %i, %j) : (!emitc.array<4x8xf32>, index, index) -> !emitc.lvalue<f32>
    %1 = "emitc.subscript"(%arg1, %i) : (!emitc.ptr<i32>, index) -> !emitc.lvalue<i32>
    return
  }

  func.func @rem(%arg0: i32, %arg1: i32) -> i32 {
    %0 = "emitc.rem"(%arg0, %arg1) : (i32, i32) -> i32
    return %0 : i32
  }

  func.func @main(%arg0: i32, %arg1: i32, %arg2: !emitc.array<4x8xf32>, %arg3: !emitc.ptr<i32>, %i: index, %j: index) -> i32 {
    // Call logical operation
    %logical_result = call @logical_operation(%arg0, %arg1) : (i32, i32) -> i1
    
    // Call bitwise operation
    %bitwise_result = call @bitwise_operation(%arg0, %arg1) : (i32, i32) -> i32
    
    // Call array operation
    call @array_operation(%arg2, %arg3, %i, %j) : (!emitc.array<4x8xf32>, !emitc.ptr<i32>, index, index) -> ()
    
    // Cast logical result to i32
    %logical_i32 = "emitc.cast"(%logical_result) : (i1) -> i32
    
    // Add bitwise result and casted logical result
    %sum_result = "emitc.add"(%bitwise_result, %logical_i32) : (i32, i32) -> i32
    
    // Call remainder operation
    %final_result = call @rem(%sum_result, %arg1) : (i32, i32) -> i32
    
    return %final_result : i32
  }
}