module {
  func.func @create_async_group(%size: index) -> !async.group {
    %group = "async.create_group"(%size) : (index) -> !async.group
    return %group : !async.group
  }

  func.func @load_value(%storage: !async.value<f32>) -> f32 {
    %result = "async.runtime.load"(%storage) : (!async.value<f32>) -> f32
    return %result : f32
  }

  func.func @main(%asyncValue: !async.value<f32>, %coroHandle: !async.coro.handle, %group_size: index) -> f32 {
    // Create an async group
    %group = call @create_async_group(%group_size) : (index) -> !async.group
    
    // Await and resume the coroutine
    "async.runtime.await_and_resume"(%asyncValue, %coroHandle) : (!async.value<f32>, !async.coro.handle) -> ()
    
    // Load the value from async storage
    %loaded_value = call @load_value(%asyncValue) : (!async.value<f32>) -> f32
    
    return %loaded_value : f32
  }
}