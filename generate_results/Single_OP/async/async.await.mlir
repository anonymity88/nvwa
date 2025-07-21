module {
  func.func @await_example(%arg0: !async.value<f32>) -> f32 {
    // Wait for the async value to become ready and unwrap the underlying value
    %result = "async.await"(%arg0) : (!async.value<f32>) -> f32
    return %result : f32
  }
}