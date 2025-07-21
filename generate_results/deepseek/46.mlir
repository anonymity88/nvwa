module {
  func.func @main(%token: !async.token, %group: !async.group) -> (!async.coro.id, index) {
    // Create a coroutine ID
    %coro_id = "async.coro.id"() : () -> !async.coro.id
    
    // Await the asynchronous token
    "async.runtime.await"(%token) : (!async.token) -> ()
    
    // Add token to group and get its rank
    %rank = "async.runtime.add_to_group"(%token, %group) : (!async.token, !async.group) -> index
    
    // Return both the coroutine ID and the rank
    return %coro_id, %rank : !async.coro.id, index
  }
}