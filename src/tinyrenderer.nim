import math, basic2d, random, basic3d

import tgaimage, model

type
  ZBuffer = seq[seq[float]]

proc newZBuffer(width, height: int): ZBuffer =
  result = newSeq[seq[float]](width)
  for x in 0 .. <width:
    result[x] = newSeq[float](height)
    for y in 0 .. <height:
      result[x][y] = -INF

let
  white = constructTGAColor(255, 255, 255, 255)
  red = constructTGAColor(255, 0, 0, 255)
  green = constructTGAColor(0, 255, 0, 255)

proc line(image: var TGAImage, x0, y0, x1, y1: int, color: TGAColor) =
  var (x0, y0, x1, y1) = (x0, y0, x1, y1)

  var steep = false
  if abs(x0-x1) < abs(y0-y1):
    swap(x0, y0)
    swap(x1, y1)
    steep = true

  if x0 > x1:
    swap(x0, x1)
    swap(y0, y1)

  for x in x0 .. x1:
    let t = (x - x0) / (x1 - x0)
    let y = y0.float * (1.0 - t) + y1.float * t
    if steep:
      discard image.set(y.cint, x.cint, color)
    else:
      discard image.set(x.cint, y.cint, color)

proc line(image: var TGAImage, a, b: Vector2d, color: TGAColor) =
  image.line(a.x.int, a.y.int, b.x.int, b.y.int, color)

proc barycentric(t0, t1, t2: Vector3d, P: Vector2d): Vector3d =
  let u = cross(vector3d(t2.x-t0.x, t1.x-t0.x, t0.x-P.x),
                vector3d(t2.y-t0.y, t1.y-t0.y, t0.y-P.y))
  if abs(u.z) < 1:
    # Triangle is degenerate.
    return vector3d(-1, 1, 1)

  return vector3d(1.0 - (u.x+u.y) / u.z, u.y / u.z, u.x / u.z)

proc triangle(image: var TGAImage, zbuffer: var ZBuffer,
              t0, t1, t2: Vector3d, color: TGAColor) =
  var minBoundingBox, clamp = vector2d(image.getWidth().float-1,
                                       image.getHeight().float-1)

  var maxBoundingBox = vector2d(0, 0)

  template getBounds(vec: Vector3d) =
    minBoundingBox.x = max(0, min(minBoundingBox.x, vec.x))
    maxBoundingBox.x = min(clamp.x, max(maxBoundingBox.x, vec.x))

    minBoundingBox.y = max(0, min(minBoundingBox.y, vec.y))
    maxBoundingBox.y = min(clamp.x, max(maxBoundingBox.y, vec.y))

  getBounds(t0)
  getBounds(t1)
  getBounds(t2)

  for x in countup(minBoundingBox.x, maxBoundingBox.x):
    for y in countup(minBoundingBox.y, maxBoundingBox.y):
      let bcScreen = barycentric(t0, t1, t2, vector2d(x.float, y.float))
      if bcScreen.x < 0 or bcScreen.y < 0 or bcScreen.z < 0:
        continue
      var z = t0.z*bcScreen.x + t1.z*bcScreen.y + t2.z*bcScreen.z
      if zbuffer[x][y] < z:
        zbuffer[x][y] = z
        doAssert image.set(x.cint, y.cint, color)

const
  width = 800
  height = 800
var image = constructTGAImage(width, height, RGB.cint)

var head = newModel("african_head.obj")

var zbuffer = newZBuffer(width, height)

# Shading.
let lightDir = vector3d(0, 0, -1)
for i in 0 .. <head.nfaces():
  let face = head.face(i)
  var screenCoords: array[3, Vector3D]
  var worldCoords: array[3, Vector3D]
  for j in 0 .. <3:
    worldCoords[j] = head.vert(face[j])
    screenCoords[j] = vector3d(
      (worldCoords[j].x+1)*width / 2,
      (worldCoords[j].y+1)*height / 2,
      worldCoords[j].z
    )

  var product = cross(worldCoords[2]-worldCoords[0],
                      worldCoords[1]-worldCoords[0])
  product.normalize()
  let intensity = dot(product, lightDir)

  if intensity > 0:
    image.triangle(zbuffer,
                   screenCoords[0], screenCoords[1], screenCoords[2],
                   constructTGAColor(int(132*intensity), int(84*intensity),
                                     int(62*intensity), 255))

# Wireframe
when false:
  for i in 0 .. <head.nfaces():
    let face = head.face(i)
    for j in 0 .. <3:
      let v0 = head.vert(face[j])
      let v1 = head.vert(face[(j+1) mod 3])

      let x0 = (v0.x+1.0) * width/2
      let y0 = (v0.y+1.0) * height/2
      let x1 = (v1.x+1.0) * width/2
      let y1 = (v1.y+1.0) * height/2
      image.line(x0.cint, y0.cint, x1.cint, y1.cint, white)

doAssert image.flipVertically()
doAssert image.writeTgaFile("output.tga")

