module {
  func.func @main(%asyncValue: !async.value<f32>, %coroHandle: !async.coro.handle) -> () {
    // Await the async value and resume the coroutine
    "async.runtime.await_and_resume"(%asyncValue, %coroHandle) : (!async.value<f32>, !async.coro.handle) -> ()
    return
  }
}