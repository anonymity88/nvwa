module {
  // Define a PDL Interpreter function named 'switch_types_example' that takes a
  // range of type values as input and switches based on the specified cases.
  pdl_interp.func @switch_types_example(%type: !pdl.range<type>) {
    // Switch on the provided range of types %type. If it matches [i32], go to ^i32Dest;
    // if it matches [i64, i64], go to ^i64Dest. Otherwise, go to ^defaultDest.
    pdl_interp.switch_types %type to [[i32], [i64, i64]](^i32Dest, ^i64Dest) -> ^defaultDest

  ^i32Dest:
    // Code specific to the i32 case.
    pdl_interp.finalize

  ^i64Dest:
    // Code specific to the i64, i64 case.
    pdl_interp.finalize

  ^defaultDest:
    // Code for cases that do not match the above specifications.
    pdl_interp.finalize
  }
}