#map10 = affine_map<(d0, d1) -> (d0 floordiv 8 + d1 floordiv 128)>
#map20 = affine_map<(i)[s0] -> (i + s0)>

module {
  func.func @main() -> () {
    // Example SSA values
    %s = arith.constant 64 : index
    %t = arith.constant 256 : index
    %n = arith.constant 10 : index
    %42 = arith.constant 42 : index

    // Application of the affine.apply operation using previously defined affine map #map10
    %result1 = affine.apply #map10(%s, %t)

    // Inline example of affine.apply operation with map #map20
    %result2 = affine.apply #map20(%42)[%n]

    return
  }
}