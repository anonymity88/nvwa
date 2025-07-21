module {
  irdl.dialect @mymath {
    irdl.type @custom_type {
      %0 = irdl.is i32
      %1 = irdl.is f32
      %2 = irdl.is f64
      %3 = irdl.any_of(%0, %1, %2)
      irdl.parameters(%3)
    }
  }

  irdl.dialect @graphics {
    irdl.type @color {
      %0 = irdl.is i8
      %1 = irdl.any_of(%0)
      irdl.parameters(%1)
    }

    irdl.operation @changeColor {
      %0 = irdl.is i8
      %1 = irdl.is i16
      %2 = irdl.any_of(%0, %1)
      irdl.results(%2)
      irdl.operands(single %2)
    }
  }

  irdl.dialect @example {
    irdl.operation @op_with_regions {
      %r1 = irdl.region with size 3
      %0 = irdl.any
      %r2 = irdl.region(%0)
      irdl.regions(%r1, %r2)
    }
  }

  irdl.dialect @cmath {
    irdl.type @advanced_complex {
      %0 = irdl.is f64
      %1 = irdl.is i64
      %2 = irdl.any_of(%0, %1)
      irdl.parameters(%2)
    }
  }

  irdl.dialect @combined {
    irdl.operation @main_op {
      %custom = irdl.is @mymath::@custom_type
      %color = irdl.is @graphics::@color
      %complex = irdl.is @cmath::@advanced_complex
      %region_op = irdl.is @example::@op_with_regions
      irdl.operands(%custom, %color, %complex, %region_op)
      irdl.results()
    }
  }

  irdl.dialect @testvar {
    irdl.operation @single_operand {
      %0 = irdl.is i32
      irdl.operands(single %0)
    }

    irdl.operation @var_operand {
      %0 = irdl.is i16
      %1 = irdl.is i32
      %2 = irdl.is i64
      irdl.operands(%0, variadic %1, %2)
    }

    irdl.operation @opt_operand {
      %0 = irdl.is i16
      %1 = irdl.is i32
      %2 = irdl.is i64
      irdl.operands(%0, optional %1, %2)
    }

    irdl.operation @var_and_opt_operand {
      %0 = irdl.is i16
      %1 = irdl.is i32
      %2 = irdl.is i64
      irdl.operands(variadic %0, optional %1, %2)
    }

    irdl.operation @single_result {
      %0 = irdl.is i32
      irdl.results(single %0)
    }

    irdl.operation @var_result {
      %0 = irdl.is i16
      %1 = irdl.is i32
      %2 = irdl.is i64
      irdl.results(%0, variadic %1, %2)
    }

    irdl.operation @opt_result {
      %0 = irdl.is i16
      %1 = irdl.is i32
      %2 = irdl.is i64
      irdl.results(%0, optional %1, %2)
    }

    irdl.operation @var_and_opt_result {
      %0 = irdl.is i16
      %1 = irdl.is i32
      %2 = irdl.is i64
      irdl.results(variadic %0, optional %1, %2)
    }
  }

  irdl.dialect @entry {
    irdl.operation @entry_point {
      %main_op = irdl.is @combined::@main_op
      %single_op = irdl.is @testvar::@single_operand
      %var_op = irdl.is @testvar::@var_operand
      irdl.operands(%main_op, %single_op, %var_op)
      irdl.results()
    }
  }
}