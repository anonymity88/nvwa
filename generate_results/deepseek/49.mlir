module {
  func.func @main(%asyncValue: !async.value<f32>, %coroHandle: !async.coro.handle) -> !async.coro.id {
    // Get the coroutine ID
    %coroId = "async.coro.id"() : () -> !async.coro.id
    
    // Await the async value and resume the coroutine
    "async.runtime.await_and_resume"(%asyncValue, %coroHandle) : (!async.value<f32>, !async.coro.handle) -> ()
    
    // Resume the coroutine handle again
    "async.runtime.resume"(%coroHandle) : (!async.coro.handle) -> ()
    
    return %coroId : !async.coro.id
  }
}