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
    irdl.operation @op_with_defined_regions {
      %region1 = irdl.region
      %region2 = irdl.region()
      %arg1 = irdl.is i32
      %arg2 = irdl.is i64
      %region3 = irdl.region(%arg1, %arg2)
      %region4 = irdl.region with size 4
      irdl.regions(%region1, %region2, %region3, %region4)
    }

    irdl.operation @combined_operation {
      %custom = irdl.is @mymath::@custom_type
      %color = irdl.is @graphics::@color
      %region = irdl.region
      irdl.operands(%custom, %color)
      irdl.regions(%region)
      irdl.results()
    }
  }

  irdl.dialect @custom_dialect {
    irdl.attribute @color_attr {
      %0 = irdl.is "red"
      %1 = irdl.is "green"
      %2 = irdl.is "blue"
      %3 = irdl.any_of(%0, %1, %2)
      irdl.parameters(%3)
    }

    irdl.operation @attr_consumer {
      %attr = irdl.is @custom_dialect::@color_attr
      %color = irdl.is @graphics::@color
      irdl.operands(%attr, %color)
      irdl.results()
    }
  }

  irdl.dialect @testd {
    irdl.type @singleton
    irdl.type @parametrized {
      %0 = irdl.any
      %1 = irdl.is i32
      %2 = irdl.is i64
      %3 = irdl.any_of(%1, %2)
      irdl.parameters(%0, %3)
    }
    irdl.operation @any {
      %0 = irdl.any
      irdl.results(%0)
    }
  }

  irdl.dialect @main {
    irdl.operation @entry_point {
      %example_op = irdl.is @example::@op_with_defined_regions
      %custom_op = irdl.is @custom_dialect::@attr_consumer
      %math_op = irdl.is @mymath::@custom_type
      irdl.operands(%example_op, %custom_op, %math_op)
      irdl.results()
    }
  }
}