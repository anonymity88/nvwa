module {
  irdl.dialect @cmath {
    irdl.type @complex_f32 {
      %0 = irdl.is i32
      %1 = irdl.is f32
      %2 = irdl.any_of(%0, %1) // is either 32-bit integer or float

      %3 = irdl.is f32
      %4 = irdl.is f64
      %5 = irdl.any_of(%3, %4) // is a float

      %6 = irdl.all_of(%2, %5) // is both a 32-bit and a float, i.e., f32
      irdl.parameters(%6)
    }
  }
}