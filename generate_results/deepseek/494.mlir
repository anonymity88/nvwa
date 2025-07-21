module {
  func.func @main() -> () {
    %types = pdl.types
    %constantTypes = pdl.types : [i32, i64, i32]
    %attr1 = pdl.attribute
    %type = pdl.type : i32
    %attr2 = pdl.attribute : %type
    %attr3 = pdl.attribute = "hello"
    %type1 = pdl.type
    %type2 = pdl.type : i32
    return
  }

  pdl.pattern : benefit(1) {
    %types = types
    %operands = operands : %types
    %root = operation (%operands : !pdl.range<value>)
    rewrite %root {
      %newOp = operation "foo.op" -> (%types : !pdl.range<type>)
    }
  }

  pdl.pattern : benefit(2) {
    %types = types : [i64]
    %root = operation -> (%types : !pdl.range<type>)
    rewrite %root with "rewriter"
  }
}