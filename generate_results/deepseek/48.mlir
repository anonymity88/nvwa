module {
  func.func @await_example(%arg0: !async.value<f32>) -> f32 {
    %result = "async.await"(%arg0) : (!async.value<f32>) -> f32
    return %result : f32
  }

  func.func @main(%storage: !async.value<f32>, %coroHandle: !async.coro.handle) -> f32 {
    // First load the value from async storage
    %loaded_value = "async.runtime.load"(%storage) : (!async.value<f32>) -> f32
    
    // Then await and resume the coroutine
    "async.runtime.await_and_resume"(%storage, %coroHandle) : (!async.value<f32>, !async.coro.handle) -> ()
    
    // Also demonstrate the await operation through a function call
    %awaited_value = func.call @await_example(%storage) : (!async.value<f32>) -> f32
    
    // Return the loaded value (could also return awaited_value)
    return %loaded_value : f32
  }
}