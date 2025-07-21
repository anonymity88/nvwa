module {
  func.func @myCoroutine(%handle: !async.coro.handle) -> () {
    "async.coro.end"(%handle) : (!async.coro.handle) -> ()
    return
  }

  func.func @load_value(%storage: !async.value<f32>) -> f32 {
    %result = "async.runtime.load"(%storage) : (!async.value<f32>) -> f32
    return %result : f32
  }

  func.func @main(%storage: !async.value<f32>, %coro_id: !async.coro.id, %handle: !async.coro.handle) -> f32 {
    // Load value from async storage
    %val = call @load_value(%storage) : (!async.value<f32>) -> f32
    
    // Free coroutine resources
    "async.coro.free"(%coro_id, %handle) : (!async.coro.id, !async.coro.handle) -> ()
    
    // End the coroutine
    call @myCoroutine(%handle) : (!async.coro.handle) -> ()
    
    return %val : f32
  }
}