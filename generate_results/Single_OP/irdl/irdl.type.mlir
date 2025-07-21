module {
  irdl.dialect @cmath {
    irdl.type @advanced_complex {
      %0 = irdl.is f64
      %1 = irdl.is i64
      %2 = irdl.any_of(%0, %1)
      irdl.parameters(%2)
    }
  }
}