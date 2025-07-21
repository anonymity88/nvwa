func.func private @private2(%0 : i32) -> i32 {
  %cond = arith.index_cast %0 {tag = "in_private2"} : i32 to index
  %1 = scf.index_switch %cond -> i32
  case 1 {
    %ten = arith.constant 10 : i32
    scf.yield %ten : i32
  }
  case 2 {
    %twenty = arith.constant 20 : i32
    scf.yield %twenty : i32
  }
  default {
    %thirty = arith.constant 30 : i32
    scf.yield %thirty : i32
  }
  func.return %1 : i32
}