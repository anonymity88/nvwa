module {
  func.func @main(%id: !async.coro.id) -> !async.coro.handle {
    // Begin the coroutine and return its handle
    %handle = "async.coro.begin"(%id) : (!async.coro.id) -> !async.coro.handle
    return %handle : !async.coro.handle
  }
}