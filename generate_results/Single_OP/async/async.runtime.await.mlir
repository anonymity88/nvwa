module {
  func.func @main(%arg0: !async.token) -> () {
    // Block the caller thread until the async token is available
    "async.runtime.await"(%arg0) : (!async.token) -> ()
    return
  }
}