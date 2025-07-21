module {
  func.func @main(%arg0: !async.token, %arg1: !async.group) -> index {
    // Add the async value to the async group
    %rank = "async.runtime.add_to_group"(%arg0, %arg1) : (!async.token, !async.group) -> index
    return %rank : index
  }
}