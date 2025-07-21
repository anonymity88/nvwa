module {
  func.func @main(%coro_id: !async.coro.id, %handle: !async.coro.handle) -> () {
    // Deallocate the coroutine frame
    "async.coro.free"(%coro_id, %handle) : (!async.coro.id, !async.coro.handle) -> ()
    return
  }
}