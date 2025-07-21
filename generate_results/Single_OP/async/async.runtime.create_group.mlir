module {
  func.func @main(%size: index) -> !async.group {
    // Create an async runtime group with the specified size
    %group = "async.runtime.create_group"(%size) : (index) -> !async.group
    return %group : !async.group
  }
}