module {
  func.func @main -> () {
    pdl.pattern : benefit(1) {
      %resultType = pdl.type
      %inputOperand = pdl.operand
      %root = pdl.operation "foo.op"(%inputOperand) -> (%resultType)
      pdl.rewrite %root {
        pdl.replace %root with (%inputOperand)
      }
    }
  }
}