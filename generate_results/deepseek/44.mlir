module {
  func.func @create_async_token() -> !async.token {
    %result = "async.runtime.create"() : () -> !async.token
    return %result : !async.token
  }

  func.func @create_async_group(%size: index) -> !async.group {
    %group = "async.runtime.create_group"(%size) : (index) -> !async.group
    return %group : !async.group
  }

  func.func @main(%asyncValue: !async.value<f32>, %coroHandle: !async.coro.handle, %size: index) -> () {
    // Create async token
    %token = call @create_async_token() : () -> !async.token
    
    // Create async group
    %group = call @create_async_group(%size) : (index) -> !async.group
    
    // Await and resume operation
    "async.runtime.await_and_resume"(%asyncValue, %coroHandle) : (!async.value<f32>, !async.coro.handle) -> ()
    
    return
  }
}