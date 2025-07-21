module {
  func.func @main() -> () {
    %types = pdl.types
    %constantTypes = pdl.types : [i32, i64, i32]
    %type1 = pdl.type
    %type2 = pdl.type : i32
    %attr1 = pdl.attribute
    %type = pdl.type : i32
    %attr2 = pdl.attribute : %type
    %attr3 = pdl.attribute = "hello"
    return
  }

  pdl.pattern : benefit(1) {
    %types = types : [i64]
    %operands = operands : %types
    %root = operation(%operands : !pdl.range<value>)
    rewrite %root with "rewriter"
  }

  pdl.pattern : benefit(2) {
    %type1 = type : i32
    %type2 = type
    %root = operation -> (%type1, %type2 : !pdl.type, !pdl.type)
    rewrite %root with "rewriter"
  }
}