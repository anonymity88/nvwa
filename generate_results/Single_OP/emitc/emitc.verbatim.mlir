module {
  func.func @main() {
    "emitc.verbatim"() {value = "#ifdef __cplusplus\nextern \"C\" {\n#endif\n"} : () -> ()
    // Additional code can be added here
    "emitc.verbatim"() {value = "#ifdef __cplusplus\n}\n#endif\n"} : () -> ()
    return
  }
}