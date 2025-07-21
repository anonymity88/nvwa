module {
  irdl.dialect @cmath {
    irdl.type @advanced_complex {
      %0 = irdl.is f64
      %1 = irdl.is i64
      %2 = irdl.any_of(%0, %1)
      irdl.parameters(%2)
    }

    irdl.type @complex {
      %0 = irdl.base "!builtin.integer"
      irdl.parameters(%0)
    }
  
    irdl.type @complex_wrapper {
      %1 = irdl.base @cmath::@complex
      irdl.parameters(%1)
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

    irdl.operation @combined_operation {
      %complex_type = irdl.is @cmath::@complex_wrapper
      %integer_type = irdl.is @custom::@integer_type
      irdl.operands(%complex_type, %integer_type)
      irdl.results()
    }
  }
}