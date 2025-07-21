module {
  func.func @main(%arg0: !async.token) -> () {
    // Switch the async token to available state
    "async.runtime.set_available"(%arg0) : (!async.token) -> ()
    return
  }
}