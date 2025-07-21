module {
  irdl.dialect @cmath {
    irdl.type @complex_type {
      %0 = irdl.is i32
      %1 = irdl.is i64
      %2 = irdl.is f32
      %3 = irdl.is f64
      %4 = irdl.any_of(%0, %1, %2, %3) // This constraint accepts any of the specified types: i32, i64, f32, or f64
      irdl.parameters(%4)
    }
  }

  irdl.dialect @geometry {
    irdl.type @shape {
      %0 = irdl.is i32
      %1 = irdl.is f32
      %2 = irdl.any_of(%0, %1) // This allows for either an i32 or an f32 parameter for shape
      irdl.parameters(%2)
    }

    irdl.operation @transform {
      %0 = irdl.is f32
      %1 = irdl.is f64
      %2 = irdl.any_of(%0, %1) // This specifies that the transform operation can operate on either f32 or f64 inputs
      irdl.results(%2)
      irdl.operands(single %2)
    }
  }
}