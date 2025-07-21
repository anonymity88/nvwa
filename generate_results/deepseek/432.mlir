module {
  func.func @add_func(%a: index, %b: index) -> index {
    %c = index.add %a, %b
    return %c : index
  }

  func.func @sub_func(%a: index, %b: index) -> index {
    %result = index.sub %a, %b
    return %result : index
  }

  func.func @mul_func(%a: index, %b: index) -> index {
    %c = index.mul %a, %b
    return %c : index
  }

  func.func @ceildivu(%n: index, %m: index) -> index {
    %result = index.ceildivu %n, %m
    return %result : index
  }

  func.func @main(%a: index, %b: index) -> (index, index, index, index) {
    %sum = call @add_func(%a, %b) : (index, index) -> index
    %difference = call @sub_func(%a, %b) : (index, index) -> index
    %product = call @mul_func(%a, %b) : (index, index) -> index
    %ceil_div = call @ceildivu(%a, %b) : (index, index) -> index
    return %sum, %difference, %product, %ceil_div : index, index, index, index
  }
}