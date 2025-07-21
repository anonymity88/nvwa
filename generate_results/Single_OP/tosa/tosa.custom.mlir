module {
  func.func @main() -> () {
    "tosa.custom"() {domain_name = "custom_op", operator_name = "my_custom_op", implementation_attrs = ""} : () -> ()
    return
  }
}