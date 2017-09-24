import basic3d, streams
import strutils

import nimasset/obj

type
  Model* = ref object
    verts: seq[Vector3d]
    faces: seq[seq[int]]

proc newModel*(filename: string): Model =
  var res = Model(
    verts: @[],
    faces: @[]
  )

  var loader: ObjLoader
  new loader

  let fs = newFileStream(filename)

  proc addVertex(x, y, z: float) =
    res.verts.add(vector3d(x, y, z))

  proc addTexture(u, v, w: float) =
    discard

  proc addFace(vi0, vi1, vi2, ti0, ti1, ti2, ni0, ni1, ni2: int) =
    res.faces.add(@[
      vi0, vi1, vi2, ti0, ti1, ti2, ni0, ni1, ni2
    ])

  loadMeshData(loader, fs, addVertex, addTexture, addFace)
  return res

proc nfaces*(model: Model): int =
  model.faces.len

proc nverts*(model: Model): int =
  model.verts.len

proc face*(model: Model, i: int): seq[int] =
  model.faces[i]

proc vert*(model: Model, i: int): Vector3d =
  model.verts[i]