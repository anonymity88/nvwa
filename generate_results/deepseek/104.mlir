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
}