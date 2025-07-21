module {
  func.func @main(%a: memref<f32>, %ifCond: i1) -> () {
    // Call testexitdataop function with conditional exit and delete
    call @testexitdataop(%a, %ifCond) : (memref<f32>, i1) -> ()
    // Call host_device_ops function for host-device operations
    call @host_device_ops(%a) : (memref<f32>) -> ()
    return
  }

  func.func @testexitdataop(%a: memref<f32>, %ifCond: i1) -> () {
    %0 = acc.getdeviceptr varPtr(%a : memref<f32>) -> memref<f32>
    // Conditional exit data operation
    acc.exit_data if(%ifCond) dataOperands(%0 : memref<f32>)
    // Delete operation
    acc.delete accPtr(%0 : memref<f32>)
    return
  }

  func.func @host_device_ops(%a: memref<f32>) -> () {
    %devptr = acc.getdeviceptr varPtr(%a : memref<f32>) -> memref<f32>
    // Host-device update operations
    acc.update_host accPtr(%devptr : memref<f32>) to varPtr(%a : memref<f32>) {structured = false}
    acc.update dataOperands(%devptr : memref<f32>)
    %accPtr = acc.update_device varPtr(%a : memref<f32>) -> memref<f32>
    acc.update dataOperands(%accPtr : memref<f32>)
    return
  }
}