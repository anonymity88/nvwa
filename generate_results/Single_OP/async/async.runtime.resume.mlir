module {
  func.func @main(%arg0: !async.coro.handle) -> () {
    // Resume the coroutine on a thread managed by the runtime
    "async.runtime.resume"(%arg0) : (!async.coro.handle) -> ()
    return
  }
}