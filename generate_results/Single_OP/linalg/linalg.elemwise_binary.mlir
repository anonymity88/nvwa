module {
  func.func @main(
    %input1: tensor<5x5xf32>,
    %input2: tensor<5x5xf32>,
    %output: tensor<5x5xf32>
  ) -> tensor<5x5xf32> {
    %result = linalg.elemwise_binary 
        {fun = #linalg.binary_fn<add>, cast = #linalg.type_fn<cast_signed>}
        ins(%input1, %input2 : tensor<5x5xf32>, tensor<5x5xf32>) 
        outs(%output : tensor<5x5xf32>) 
        -> tensor<5x5xf32>

    return %result : tensor<5x5xf32>
  }
}