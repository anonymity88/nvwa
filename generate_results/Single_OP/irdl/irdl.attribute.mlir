module {
  irdl.dialect @custom_dialect {
    irdl.attribute @color_attr {
      %0 = irdl.is "red"
      %1 = irdl.is "green"
      %2 = irdl.is "blue"
      %3 = irdl.any_of(%0, %1, %2)
      irdl.parameters(%3)
    }
  }
}