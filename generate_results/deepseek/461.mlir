#my_poly = #polynomial.int_polynomial<1 + x**1024>
#ring1 = #polynomial.ring<coefficientType = i32, coefficientModulus = 2837465 : i32, polynomialModulus=#my_poly>
!ty = !polynomial.polynomial<ring=#ring1>

#my_poly_3 = #polynomial.int_polynomial<4x>
#ring3 = #polynomial.ring<coefficientType = i32, coefficientModulus=12 : i32, polynomialModulus=#my_poly_3>
!ty3 = !polynomial.polynomial<ring=#ring3>

module {
  func.func @main(%arg0: !ty, %arg1: !ty3) -> (!ty, !ty3) {
    %0 = call @test_types(%arg0) : (!ty) -> !ty
    %1 = call @test_linear_poly(%arg1) : (!ty3) -> !ty3
    return %0, %1 : !ty, !ty3
  }

  func.func @test_types(%0: !ty) -> !ty {
    return %0 : !ty
  }

  func.func @test_linear_poly(%0: !ty3) -> !ty3 {
    return %0 : !ty3
  }
}