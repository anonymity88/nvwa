module {
  // Define the main function with an argument of type 1-bit signless integer (boolean).
  func.func @main(%cond: i1) -> () {
    // Use the cf.assert operation with a condition and an error message.
    // If the condition (%cond) is true, execution continues; otherwise, the program terminates with an error message.
    cf.assert %cond, "The condition was expected to be true, but it was false."

    // Add a return terminator operation for the function.
    return
  }
}