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

  irdl.dialect @custom {
    irdl.type @integer_type {
      %0 = irdl.c_pred "::llvm::isa<::mlir::IntegerAttr>($_self)"
      irdl.parameters(%0)
    }

    irdl.operation @verifyInteger {
      %0 = irdl.c_pred "::llvm::isa<::mlir::IntegerAttr>($_self)"
      irdl.results(%0)
    }

    irdl.operation @checkFloat {
      %0 = irdl.c_pred "!::llvm::isa<::mlir::IntegerAttr>($_self)"
      irdl.results(%0)
    }

    irdl.operation @combined_verification {
      %int_result = irdl.is @custom::@verifyInteger
      %float_result = irdl.is @custom::@checkFloat
      irdl.operands(%int_result, %float_result)
      irdl.results()
    }
  }

  irdl.dialect @cmath {
    irdl.type @complex {
    }

    irdl.operation @calculate_norm {
      %0 = irdl.is f64
      irdl.operands(%0)
      irdl.results(%0, single %0, optional %0, variadic %0)
    }

    irdl.operation @complex_operation {
      %norm_result = irdl.is @cmath::@calculate_norm
      %custom_int = irdl.is @custom::@integer_type
      irdl.operands(%norm_result, %custom_int)
      %region = irdl.region with size 2
      irdl.regions(%region)
      irdl.results()
    }
  }

  irdl.dialect @main {
    irdl.operation @entry_point {
      %example_op = irdl.is @example::@op_with_defined_regions
      %custom_op = irdl.is @custom::@combined_verification
      %cmath_op = irdl.is @cmath::@complex_operation
      irdl.operands(%example_op, %custom_op, %cmath_op)
      irdl.results()
    }
  }
}