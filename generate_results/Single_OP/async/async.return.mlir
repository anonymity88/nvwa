module {
  async.func @foo() -> !async.token {
    // Return from the async function without any operands
    "async.return"() : () -> ()
  }
}