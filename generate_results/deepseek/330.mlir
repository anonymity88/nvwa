module {
  func.func @main() {
    // Constants from @entry function
    %i = arith.constant 2147483647: i32
    %l = arith.constant 9223372036854775807 : i64
    %f0 = arith.constant 0.0: f32
    %f1 = arith.constant 1.0: f32
    %f2 = arith.constant 2.0: f32
    %f3 = arith.constant 3.0: f32
    %f4 = arith.constant 4.0: f32
    %f5 = arith.constant 5.0: f32

    // Vector operations from @entry function
    %vi = vector.broadcast %i : i32 to vector<2xi32>
    %vl = vector.broadcast %l : i64 to vector<2xi64>
    %vf = vector.broadcast %f1 : f32 to vector<2x2x2xf32>
    vector.print %vi : vector<2xi32>
    vector.print %vl : vector<2xi64>
    vector.print %vf : vector<2x2x2xf32>

    %v0 = vector.broadcast %f1 : f32 to vector<4xf32>
    %v1 = vector.insert %f2, %v0[1] : f32 into vector<4xf32>
    %v2 = vector.insert %f3, %v1[2] : f32 into vector<4xf32>
    %v3 = vector.insert %f4, %v2[3] : f32 into vector<4xf32>
    %v4 = vector.broadcast %v3 : vector<4xf32> to vector<3x4xf32>
    %v5 = vector.broadcast %v3 : vector<4xf32> to vector<2x2x4xf32>
    vector.print %v3 : vector<4xf32>
    vector.print %v4 : vector<3x4xf32>
    vector.print %v5 : vector<2x2x4xf32>

    %x = vector.broadcast %f5 : f32 to vector<1xf32>
    %y = vector.broadcast %x : vector<1xf32> to vector<8xf32>
    vector.print %y : vector<8xf32>

    %s = vector.broadcast %v3 : vector<4xf32> to vector<1x4xf32>
    %t = vector.broadcast %s : vector<1x4xf32> to vector<3x4xf32>
    vector.print %s : vector<1x4xf32>
    vector.print %t : vector<3x4xf32>

    %a0 = vector.broadcast %f1 : f32 to vector<3x1xf32>
    %a1 = vector.insert %f2, %a0[1, 0] : f32 into vector<3x1xf32>
    %a2 = vector.insert %f3, %a1[2, 0] : f32 into vector<3x1xf32>
    %a3 = vector.broadcast %a2 : vector<3x1xf32> to vector<3x4xf32>
    vector.print %a2 : vector<3x1xf32>
    vector.print %a3 : vector<3x4xf32>

    %m0 = vector.broadcast %f0 : f32 to vector<3x1x2xf32>
    %m1 = vector.insert %f1, %m0[0, 0, 1] : f32 into vector<3x1x2xf32>
    %m2 = vector.insert %f2, %m1[1, 0, 0] : f32 into vector<3x1x2xf32>
    %m3 = vector.insert %f3, %m2[1, 0, 1] : f32 into vector<3x1x2xf32>
    %m4 = vector.insert %f4, %m3[2, 0, 0] : f32 into vector<3x1x2xf32>
    %m5 = vector.insert %f5, %m4[2, 0, 1] : f32 into vector<3x1x2xf32>
    %m6 = vector.broadcast %m5 : vector<3x1x2xf32> to vector<3x4x2xf32>
    vector.print %m5 : vector<3x1x2xf32>
    vector.print %m6 : vector<3x4x2xf32>

    // Original @main operations
    %matrix = arith.constant dense<[1.0, 2.0, 3.0, 4.0, 
                                    5.0, 6.0, 7.0, 8.0, 
                                    9.0, 10.0, 11.0, 12.0, 
                                    13.0, 14.0, 15.0, 16.0]> : vector<16xf32>
    %transposed = vector.flat_transpose %matrix {rows = 4 : i32, columns = 4 : i32} : vector<16xf32> -> vector<16xf32>

    %base1 = memref.alloc() : memref<16xf32>
    %i1 = arith.constant 0 : index
    %mask1 = arith.constant dense<[1, 0, 1, 0, 1, 0, 1, 0]> : vector<8xi1>
    %valueToStore = arith.constant dense<[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]> : vector<8xf32>
    vector.maskedstore %base1[%i1], %mask1, %valueToStore : memref<16xf32>, vector<8xi1>, vector<8xf32>

    %base2 = memref.alloc() : memref<32xf32>
    %i2 = arith.constant 0 : index
    %mask2 = arith.constant dense<[1, 0, 1, 1, 0, 1, 0, 1]> : vector<8xi1>
    %pass_thru = arith.constant dense<[10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0, 80.0]> : vector<8xf32>
    %result = vector.expandload %base2[%i2], %mask2, %pass_thru 
      : memref<32xf32>, vector<8xi1>, vector<8xf32> into vector<8xf32>

    return
  }
}