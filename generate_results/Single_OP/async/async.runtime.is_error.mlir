module {
  func.func @check_error(%async_value: !async.token) -> i1 {
    // Check if the async value is in the error state
    %is_error = "async.runtime.is_error"(%async_value) : (!async.token) -> i1
    return %is_error : i1
  }
}