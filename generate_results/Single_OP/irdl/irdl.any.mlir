module {
  irdl.dialect @cmath {
    irdl.type @complex_flexible {
      %0 = irdl.any
      irdl.parameters(%0)
    }
    
    irdl.attribute @flexible_constraint {
      %1 = irdl.any
      irdl.parameters(%1)
    }
    
    irdl.operation @flexible_op {
      %2 = irdl.any
      irdl.operands(%2)
      irdl.results()
    }
  }
}