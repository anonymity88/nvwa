module {
  // Function to create an async group using the high-level operation
  func.func @create_async_group(%size: index) -> !async.group {
    %group = "async.create_group"(%size) : (index) -> !async.group
    return %group : !async.group
  }

  // Async function that returns a token
  async.func @foo() -> !async.token {
    "async.return"() : () -> ()
  }

  // Main function that demonstrates the usage of both operations
  func.func @main(%size: index) -> !async.group {
    // Create group using both methods
    %group1 = "async.runtime.create_group"(%size) : (index) -> !async.group
    %group2 = func.call @create_async_group(%size) : (index) -> !async.group
    
    // Launch the async function
    %token = async.call @foo() : () -> !async.token
    
    // Return one of the groups (could use either)
    return %group1 : !async.group
  }
}