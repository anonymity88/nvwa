module {
  func.func @create_async_token() -> !async.token {
    // Create a new async token in the non-ready state
    %result = "async.runtime.create"() : () -> !async.token
    return %result : !async.token
  }
}