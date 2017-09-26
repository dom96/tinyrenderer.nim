import math, basic2d, random, basic3d

import tgaimage, model


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

proc triangle(image: var TGAImage, t0, t1, t2: Vector2d, color: TGAColor) =
  var (t0, t1, t2) = (t0, t1, t2)
  # Sort the vertices from lower-to-upper y.
  if t0.y > t1.y: swap(t0, t1)
  if t0.y > t2.y: swap(t0, t2)
  if t1.y > t2.y: swap(t1, t2)

  let totalHeight = t2.y - t0.y
  template fillSegment(a, b) =
    for y in countup(a.y, b.y, 1.0):
      let segmentHeight = b.y - a.y
      let alpha = (y.float - t0.y) / totalHeight
      let beta = (y.float - a.y) / segmentHeight
      var A = t0 + (t2-t0)*alpha
      var B = a + (b-a)*beta

      if A.x > B.x: swap(A, B)
      for x in countup(A.x, B.x):
        discard image.set(x.cint, y.cint, color)

  fillSegment(t0, t1)
  fillSegment(t1, t2)
  image.line(t0, t1, color)
  image.line(t1, t2, color)
  image.line(t2, t0, color)


const
  width = 800
  height = 800
var image = constructTGAImage(width, height, RGB.cint)

var head = newModel("african_head.obj")
# Shading.
let lightDir = vector3d(0, 0, -1)
for i in 0 .. <head.nfaces():
  let face = head.face(i)
  var screenCoords: array[3, Vector2D]
  var worldCoords: array[3, Vector3D]
  for j in 0 .. <3:
    worldCoords[j] = head.vert(face[j])
    screenCoords[j] = vector2d(
      (worldCoords[j].x+1)*width / 2,
      (worldCoords[j].y+1)*height / 2
    )

  var product = cross(worldCoords[2]-worldCoords[0],
                      world_coords[1]-world_coords[0])
  product.normalize()
  let intensity = dot(product, lightDir)

  if intensity > 0:
    image.triangle(screenCoords[0], screenCoords[1], screenCoords[2],
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

