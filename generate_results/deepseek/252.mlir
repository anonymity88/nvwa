module {
  func.func @extern_c_guards() {
    "emitc.verbatim"() {value = "#ifdef __cplusplus\nextern \"C\" {\n#endif\n"} : () -> ()
    "emitc.verbatim"() {value = "#ifdef __cplusplus\n}\n#endif\n"} : () -> ()
    return
  }

  func.func @get_address(%arg0: !emitc.lvalue<i32>) -> !emitc.ptr<i32> {
    %0 = emitc.apply "&"(%arg0) : (!emitc.lvalue<i32>) -> !emitc.ptr<i32>
    return %0 : !emitc.ptr<i32>
  }

  func.func @load_value(%arg0: !emitc.lvalue<i32>) -> i32 {
    %1 = emitc.load %arg0 : !emitc.lvalue<i32>
    return %1 : i32
  }

  func.func @add_pointer(%arg0: !emitc.ptr<f32>, %arg1: i32, %arg2: !emitc.opaque<"unsigned int">) {
    %1 = "emitc.add" (%arg0, %arg1) : (!emitc.ptr<f32>, i32) -> !emitc.ptr<f32>
    %2 = "emitc.add" (%arg0, %arg2) : (!emitc.ptr<f32>, !emitc.opaque<"unsigned int">) -> !emitc.ptr<f32>
    return
  }

  func.func @main() -> i32 {
    call @extern_c_guards() : () -> ()

    // Initialize variables with proper types
    %local_var = "emitc.variable"() {value = 42 : i32} : () -> !emitc.lvalue<i32>
    %unsigned_val = "emitc.variable"() {value = 2 : i32} : () -> !emitc.lvalue<i32>
    %fptr = "emitc.variable"() {value = 0 : i32} : () -> !emitc.lvalue<i32>

    // Get pointer to local variable
    %ptr = call @get_address(%local_var) : (!emitc.lvalue<i32>) -> !emitc.ptr<i32>

    // Load value from local variable
    %value = call @load_value(%local_var) : (!emitc.lvalue<i32>) -> i32

    // Cast operations with proper type handling
    %fptr_cast = emitc.cast %value : i32 to !emitc.ptr<f32>
    %unsigned_cast = emitc.cast %value : i32 to !emitc.opaque<"unsigned int">

    // Call add_pointer with properly typed arguments
    call @add_pointer(%fptr_cast, %value, %unsigned_cast) : (!emitc.ptr<f32>, i32, !emitc.opaque<"unsigned int">) -> ()

    return %value : i32
  }
}