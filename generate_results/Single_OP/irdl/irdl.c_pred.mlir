module {
  irdl.dialect @custom {
    irdl.type @integer_type {
      // Define a constraint that specifies this type uses an IntegerAttr attribute
      %0 = irdl.c_pred "::llvm::isa<::mlir::IntegerAttr>($_self)"
      irdl.parameters(%0)
    }

    irdl.operation @verifyInteger {
      // The operation checks if a parameter attribute is an IntegerAttr
      %0 = irdl.c_pred "::llvm::isa<::mlir::IntegerAttr>($_self)"
      irdl.results(%0)
    }

    irdl.operation @checkFloat {
      // Define a constraint to ensure the attribute is not an IntegerAttr
      %0 = irdl.c_pred "!::llvm::isa<::mlir::IntegerAttr>($_self)"
      irdl.results(%0)
    }
  }
}