module {
  func.func @main() -> (i32, complex<f32>) {
    %0 = call @func() : () -> i32
    %1 = call @poison_complex() : () -> complex<f32>
    return %0, %1 : i32, complex<f32>
  }
  func.func @func() -> i32 {
    %0 = ub.poison : i32
    return %0 : i32
  }
  func.func @poison_complex() -> complex<f32> {
    %0 = ub.poison : complex<f32>
    return %0 : complex<f32>
  }
}