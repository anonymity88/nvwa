module {
  irdl.dialect @cmath {

    irdl.type @complex {
      // Type definition for @complex
    }

    irdl.operation @add {
      %0 = irdl.any
      %1 = irdl.parametric @cmath::@complex<%0>
      irdl.results(%1)
      irdl.operands(single %0, variadic %1)
    }

    irdl.operation @norm {
      %0 = irdl.any
      %1 = irdl.parametric @cmath::@complex<%0>
      irdl.results(%0)
      irdl.operands(%1)
    }
  }

  irdl.dialect @example {

    irdl.operation @exampleOp {
      %0 = irdl.is i32
      %1 = irdl.is f32
      %2 = irdl.any_of(%0, %1) // is either i32 or f32
      irdl.operands(single %2, optional %0, variadic %1)
    }
  }
}