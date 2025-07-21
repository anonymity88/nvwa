module {
  emitc.global @x : !emitc.array<2xf32> = dense<0.0>
  emitc.global @y : !emitc.array<3xi32> = dense<[0, 1, 2]>
  emitc.global extern @z : !emitc.array<2xf32>
  emitc.global static const @w : i32 = 0
}