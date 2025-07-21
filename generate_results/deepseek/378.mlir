module {
  func.func private @getTensor() -> tensor<4xf32> {
    %tensor = tensor.empty() : tensor<4xf32>
    return %tensor : tensor<4xf32>
  }

  func.func private @processTensor(%arg: tensor<4xf32>) -> () {
    return
  }

  func.func @scf_for_with_tensor.insert_slice(
      %A : tensor<?xf32> {bufferization.writable = false},
      %B : tensor<?xf32> {bufferization.writable = true},
      %C : tensor<4xf32> {bufferization.writable = false},
      %lb : index, %ub : index, %step : index)
    -> (tensor<?xf32>, tensor<?xf32>)
  {
    %r0:2 = scf.for %i = %lb to %ub step %step iter_args(%tA = %A, %tB = %B)
        -> (tensor<?xf32>, tensor<?xf32>)
    {
      %ttA = tensor.insert_slice %C into %tA[0][4][1] : tensor<4xf32> into tensor<?xf32>
      %ttB = tensor.insert_slice %C into %tB[0][4][1] : tensor<4xf32> into tensor<?xf32>
      scf.yield %ttA, %ttB : tensor<?xf32>, tensor<?xf32>
    }
    return %r0#0, %r0#1: tensor<?xf32>, tensor<?xf32>
  }

  func.func @main(%a: i32, %b: i32, %flag: i1, %cond: i1,
                  %A: tensor<?xf32>, %B: tensor<?xf32>,
                  %lb: index, %ub: index, %step: index) 
                  -> (i32, tensor<?xf32>, tensor<?xf32>) {
    cf.assert %cond, "The condition was expected to be true, but it was false."
    
    %0 = call @getTensor() : () -> tensor<4xf32>
    cf.br ^bb1(%0 : tensor<4xf32>)

  ^bb1(%arg0: tensor<4xf32>):
    call @processTensor(%arg0) : (tensor<4xf32>) -> ()
    
    %processed_A, %processed_B = call @scf_for_with_tensor.insert_slice(
        %A, %B, %arg0, %lb, %ub, %step) : 
        (tensor<?xf32>, tensor<?xf32>, tensor<4xf32>, index, index, index) -> (tensor<?xf32>, tensor<?xf32>)
    
    cf.cond_br %flag, ^bb2(%a : i32), ^bb3(%b : i32)

  ^bb2(%x: i32):
    return %x, %processed_A, %processed_B : i32, tensor<?xf32>, tensor<?xf32>

  ^bb3(%y: i32):
    return %y, %processed_A, %processed_B : i32, tensor<?xf32>, tensor<?xf32>
  }
}