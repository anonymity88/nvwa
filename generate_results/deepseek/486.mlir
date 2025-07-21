#NOutOfM = #sparse_tensor.encoding<{
  map = ( i, j, k ) ->
  ( i            : dense,
    k floordiv 8 : dense,
    j            : dense,
    k mod 8      : structured[5, 8]
  )
}>
#SparseMatrix = #sparse_tensor.encoding<{map = (d0, d1) -> (d0 : compressed, d1 : compressed)}>

module {
  func.func @main(%arg0: tensor<?x?x?xf64, #NOutOfM>, %arg1: f64) -> i64 {
    call @NOutOfM(%arg0) : (tensor<?x?x?xf64, #NOutOfM>) -> ()
    %0 = call @sparse_unary(%arg1) : (f64) -> i64
    return %0 : i64
  }

  func.func private @NOutOfM(%arg0: tensor<?x?x?xf64, #NOutOfM>) {
    return
  }

  func.func @sparse_unary(%arg0: f64) -> i64 {
    %r = sparse_tensor.unary %arg0 : f64 to i64
      present={
        ^bb0(%x: f64):
          %ret = arith.fptosi %x : f64 to i64
          sparse_tensor.yield %ret : i64
      }
      absent={}
    return %r : i64
  }
}