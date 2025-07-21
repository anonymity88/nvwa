module {
  irdl.dialect @cmath {
    irdl.type @complex {
    }

    irdl.operation @norm {
      %0 = irdl.any                        // Placeholder for any type or attribute
      %1 = irdl.parametric @cmath::@complex<%0> // Defines @complex with parameter %0
      irdl.operands(%1)                    // Specifies operands for the operation
      irdl.results(%0)                     // Specifies results for the operation
    }

    irdl.type @advanced_complex {
      %2 = irdl.is f64
      %3 = irdl.is i64
      %4 = irdl.any_of(%2, %3)
      irdl.parameters(%4)
    }

    irdl.operation @complex_op {
      %complex_type = irdl.is @cmath::@advanced_complex
      %norm_result = irdl.is @cmath::@norm
      irdl.operands(%complex_type, %norm_result)
      irdl.results()
    }
  }

  irdl.dialect @example {
    irdl.operation @op_with_regions {
      %r1 = irdl.region with size 3
      %0 = irdl.any
      %r2 = irdl.region(%0)
      irdl.regions(%r1, %r2)
    }

    irdl.operation @call_cmath_ops {
      %complex_result = irdl.is @cmath::@complex_op
      %region_op = irdl.is @example::@op_with_regions
      irdl.operands(%complex_result, %region_op)
      irdl.results()
    }
  }
}