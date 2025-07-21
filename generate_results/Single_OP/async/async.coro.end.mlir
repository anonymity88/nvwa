module {
  func.func @myCoroutine(%handle: !async.coro.handle) -> () {
    // Mark the end of the coroutine with the provided handle
    "async.coro.end"(%handle) : (!async.coro.handle) -> ()
    return
  }
}