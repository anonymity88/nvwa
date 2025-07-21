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
}