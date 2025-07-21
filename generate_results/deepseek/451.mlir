module {
  irdl.dialect @cmath {
    irdl.type @complex_flexible {
      %0 = irdl.any
      irdl.parameters(%0)
    }
    
    irdl.attribute @flexible_constraint {
      %1 = irdl.any
      irdl.parameters(%1)
    }
    
    irdl.operation @flexible_op {
      %2 = irdl.any
      irdl.operands(%2)
      irdl.results()
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

  irdl.dialect @dialect {
    irdl.type @type {
      %0 = irdl.c_pred "::llvm::isa<::mlir::IntegerAttr>($_self)"
      irdl.parameters(%0)
    }
  }

  irdl.dialect @combined {
    irdl.operation @main_op {
      %flexible_type = irdl.is @cmath::@complex_flexible
      %custom_type = irdl.is @mymath::@custom_type
      %color_type = irdl.is @graphics::@color
      %dialect_type = irdl.is @dialect::@type
      
      %region_op = irdl.is @example::@op_with_regions
      %color_op = irdl.is @graphics::@changeColor
      %flex_op = irdl.is @cmath::@flexible_op
      
      irdl.operands(%flexible_type, %custom_type, %color_type, %dialect_type, %region_op, %color_op, %flex_op)
      irdl.results()
    }
  }

  irdl.dialect @entry {
    irdl.operation @program_start {
      %main = irdl.is @combined::@main_op
      irdl.operands(%main)
      irdl.results()
    }
  }
}