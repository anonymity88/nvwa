func.func @testenterdataop(%a: memref<f32>) -> () {
  %0 = acc.create varPtr(%a : memref<f32>) -> memref<f32>
  return
}