func.func @test_variable_write_type(%arg0: tensor<2x4x8xi16>) -> () {
  tosa.variable @stored_var = dense<-1> : tensor<2x4x8xi32>
  tosa.variable.write @stored_var, %arg0 : tensor<2x4x8xi16>
  return
}