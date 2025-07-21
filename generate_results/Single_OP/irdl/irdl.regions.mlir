module {
  irdl.dialect @example {
    irdl.operation @op_with_regions {
      %r1 = irdl.region with size 3
      %0 = irdl.any
      %r2 = irdl.region(%0)
      irdl.regions(%r1, %r2)
    }
  }
}