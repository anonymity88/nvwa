module {
  irdl.dialect @cmath {
    irdl.type @complex {
      %0 = irdl.base "!builtin.integer"
      irdl.parameters(%0)
    }
  
    irdl.type @complex_wrapper {
      %1 = irdl.base @cmath::@complex
      irdl.parameters(%1)
    }
  }
}