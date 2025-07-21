module {
  func.func @main() {
    // Set the default GPU to device with index 0
    %devIndex = arith.constant 0 : i32
    gpu.set_default_device %devIndex

    return
  }
}