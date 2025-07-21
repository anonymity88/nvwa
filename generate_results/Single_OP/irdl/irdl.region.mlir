module {
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
  }
}