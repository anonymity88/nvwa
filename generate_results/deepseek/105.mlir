module {
  irdl.dialect @mymath {
    irdl.type @custom_type {
      %0 = irdl.is i32
      %1 = irdl.is f32
      %2 = irdl.is f64
      %3 = irdl.any_of(%0, %1, %2) // This parameter could be either i32, f32, or f64
      irdl.parameters(%3)
    }
  }

  irdl.dialect @graphics {
    irdl.type @color {
      %0 = irdl.is i8
      %1 = irdl.any_of(%0) // Parameter accepts i8 values for color components
      irdl.parameters(%1)
    }

    irdl.operation @changeColor {
      %0 = irdl.is i8
      %1 = irdl.is i16
      %2 = irdl.any_of(%0, %1) // Operation can accept either i8 or i16 inputs for color change
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
}