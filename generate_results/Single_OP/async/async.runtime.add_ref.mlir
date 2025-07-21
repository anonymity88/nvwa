module {
  func.func @main(%arg0: !async.token) -> () {
    // Add a reference to the async token
    "async.runtime.add_ref"(%arg0) {"count" = 1} : (!async.token) -> ()
    return
  }
}