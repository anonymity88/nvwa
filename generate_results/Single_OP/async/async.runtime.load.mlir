module {
  func.func @main(%storage: !async.value<f32>) -> f32 {
    // Load the value from the async runtime storage
    %result = "async.runtime.load"(%storage) : (!async.value<f32>) -> f32
    return %result : f32
  }
}