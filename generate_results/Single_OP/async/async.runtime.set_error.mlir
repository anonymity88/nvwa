module {
  func.func @main(%arg0: !async.token) -> () {
    // Switch the async token to error state
    "async.runtime.set_error"(%arg0) : (!async.token) -> ()
    return
  }
}