module {
  func.func @main() -> !ml_program.token {
    %token = "ml_program.token"() : () -> !ml_program.token
    // The token can be used to chain operations for execution ordering
    return %token : !ml_program.token
  }
}