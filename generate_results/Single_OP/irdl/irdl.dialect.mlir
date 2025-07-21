module {
  irdl.dialect @cmath {
    irdl.operation @complex_addition {
      %0 = irdl.is "real"
      %1 = irdl.is "imaginary"
      irdl.operands(%0, %1)
      irdl.results(%0, %1)
    }
  }
}