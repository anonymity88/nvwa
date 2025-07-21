module {
  func.func @main(%memref: memref<2x?xi1>) {
    %c0 = arith.constant 0 : index
    // Load a 2-D svbool mask from memory
    %source = vector.load %memref[%c0, %c0] : memref<2x?xi1>, vector<2x[16]xi1>
    // Convert the loaded svbool to a mask of SVE predicates
    %result = arm_sve.convert_from_svbool %source : vector<2x[16]xi1>
    return
  }
}