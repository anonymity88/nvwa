module {
  shape.function_library @my_function_library {
    func.func @same_result_shape(%arg: !shape.value_shape) -> !shape.shape {
      %0 = shape.shape_of %arg : !shape.value_shape -> !shape.shape
      return %0 : !shape.shape
    }
  } mapping {
    "std.atan" = @same_result_shape
  }
}