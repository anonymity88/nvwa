module {
  spirv.SpecConstant @spec_const1 = true
  spirv.SpecConstant @spec_const2 spec_id(5) = 42 : i32

  func.func @main() -> () {
    // The main function implementation would go here.
    return
  }
}