module {
  func.func @create_async_group(%size: index) -> !async.group {
    // Create an empty async group with the specified size
    %group = "async.create_group"(%size) : (index) -> !async.group
    return %group : !async.group
  }
}