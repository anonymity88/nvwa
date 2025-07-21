module {
  func.func @main() {
    %dev1 = arith.constant 0 : i32
    acc.init device_num(%dev1 : i32)
    return
  }
}