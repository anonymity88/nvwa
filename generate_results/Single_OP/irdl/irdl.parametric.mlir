module {
  irdl.dialect @cmath {

    irdl.type @complex {
      // Define the complex type
    }

    irdl.operation @norm {
      %0 = irdl.any                        // Placeholder for any type or attribute
      %1 = irdl.parametric @cmath::@complex<%0> // Defines @complex with parameter %0
      irdl.operands(%1)                    // Specifies operands for the operation
      irdl.results(%0)                     // Specifies results for the operation
    }
  }
}