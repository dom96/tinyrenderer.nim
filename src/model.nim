{.compile: "model.cpp".}
import
  geometry

type
  Model* {.importcpp: "Model", header: "model.h".} = object

type
  Vector* {.importcpp: "std::vector", header: "model.h".}[T] = object

proc constructModel*(filename: cstring): Model {.constructor, importcpp: "Model(@)",
    header: "model.h".}
proc destroyModel*(this: var Model) {.importcpp: "#.~Model()", header: "model.h".}
proc nverts*(this: var Model): cint {.importcpp: "nverts", header: "model.h".}
proc nfaces*(this: var Model): cint {.importcpp: "nfaces", header: "model.h".}
proc vert*(this: var Model; i: cint): Vec3f {.importcpp: "vert", header: "model.h".}
proc face*(this: var Model; idx: cint): Vector[cint] {.importcpp: "face",
    header: "model.h".}

proc `[]`*[T](vec: Vector[T], i: int): T {.importcpp: "#[@]", header: "model.h".}