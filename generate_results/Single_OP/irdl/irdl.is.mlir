module {
  irdl.dialect @cmath {
    irdl.type @complex_i32 {
      %0 = irdl.is i32
      irdl.parameters(%0)
    }

    irdl.attribute @float_precision {
      %1 = irdl.is f32
      irdl.parameters(%1)
    }

    irdl.operation @math_op {
      %2 = irdl.is @cmath::@complex_i32
      %3 = irdl.is @cmath::@float_precision
      irdl.operands(%2, %3)
      irdl.results()
    }
  }
}