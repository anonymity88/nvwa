module {
  func.func @main() -> !async.coro.id {
    // Returns a switched-resume coroutine identifier
    %id = "async.coro.id"() : () -> !async.coro.id
    return %id : !async.coro.id
  }
}