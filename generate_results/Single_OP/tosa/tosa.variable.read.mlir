func.func @test_variable_read_type(%arg0: tensor<2x4x8xi32>) -> () {
  tosa.variable @stored_var = dense<-1> : tensor<2x4x8xi32>
  %0 = tosa.variable.read @stored_var : tensor<2x4x8xi16>
  return
}