module {
  irdl.dialect @example {
    irdl.operation @op_with_regions {
      %r1 = irdl.region with size 3
      %0 = irdl.any
      %r2 = irdl.region(%0)
      irdl.regions(%r1, %r2)
    }
  }

  irdl.dialect @cmath {
    irdl.type @complex {
      %0 = irdl.base "!builtin.integer"
      irdl.parameters(%0)
    }
  
    irdl.type @complex_wrapper {
      %1 = irdl.base @cmath::@complex
      irdl.parameters(%1)
    }

    irdl.type @complex_flexible {
      %2 = irdl.any
      irdl.parameters(%2)
    }
    
    irdl.attribute @flexible_constraint {
      %3 = irdl.any
      irdl.parameters(%3)
    }
    
    irdl.operation @flexible_op {
      %4 = irdl.any
      irdl.operands(%4)
      irdl.results()
    }

    irdl.operation @combined_operation {
      %complex_type = irdl.is @cmath::@complex
      %wrapper_type = irdl.is @cmath::@complex_wrapper
      %flexible_type = irdl.is @cmath::@complex_flexible
      %constraint = irdl.is @cmath::@flexible_constraint
      %region_op = irdl.is @example::@op_with_regions
      irdl.operands(%complex_type, %wrapper_type, %flexible_type, %constraint, %region_op)
      irdl.results()
    }
  }
}