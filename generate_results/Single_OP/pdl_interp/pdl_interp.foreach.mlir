module {
  // Define a PDL Interpreter function named 'foreach_example' that takes a
  // range of operations as input.
  pdl_interp.func @foreach_example(%ops: !pdl.range<operation>) {
    // Iterate over each operation in the range '%ops'.
    pdl_interp.foreach %op : !pdl.operation in %ops {
      // Continue execution within the foreach loop.
      pdl_interp.continue
    } -> ^next
  ^next:
    // Finalize the interpreter function execution
    pdl_interp.finalize
  }
}