
type
  Vec3* {.importcpp: "Vec3", header: "geometry.h".}[t] = object
      x* {.importc: "x".}: t
      y* {.importc: "y".}: t
      z* {.importc: "z".}: t

proc constructVec3*[t](): Vec3[t] {.constructor, importcpp: "Vec3(@)",
                                 header: "geometry.h".}
# proc constructVec3*[t](_x: t; _y: t; _z: t): Vec3[t] {.constructor, importcpp: "Vec3(@)",
#     header: "geometry.h".}
proc `^`*[t](this: Vec3[t]; v: Vec3[t]): Vec3[t] {.noSideEffect, importcpp: "(# ^ #)",
    header: "geometry.h".}
proc `+`*[t](this: Vec3[t]; v: Vec3[t]): Vec3[t] {.noSideEffect, importcpp: "(# + #)",
    header: "geometry.h".}
proc `-`*[t](this: Vec3[t]; v: Vec3[t]): Vec3[t] {.noSideEffect, importcpp: "(# - #)",
    header: "geometry.h".}
proc `*`*[t](this: Vec3[t]; f: cfloat): Vec3[t] {.noSideEffect, importcpp: "(# * #)",
    header: "geometry.h".}
proc `*`*[t](this: Vec3[t]; v: Vec3[t]): t {.noSideEffect, importcpp: "(# * #)",
                                       header: "geometry.h".}
proc norm*[t](this: Vec3[t]): cfloat {.noSideEffect, importcpp: "norm",
                                   header: "geometry.h".}
proc normalize*[t](this: var Vec3[t]; l: t = 1): var Vec3[t] {.importcpp: "normalize",
    header: "geometry.h".}
type
  Vec3f* = Vec3[cfloat]
  Vec3i* = Vec3[cint]

# proc `<<`*(s: var ostream; v: var Vec2[t]): var ostream {.importcpp: "(# << #)",
#     header: "geometry.h".}
# proc `<<`*(s: var ostream; v: var Vec3[t]): var ostream {.importcpp: "(# << #)",
#     header: "geometry.h".}