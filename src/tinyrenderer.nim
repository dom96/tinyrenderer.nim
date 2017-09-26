import math, basic2d

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

image.triangle(vector2d(10, 70), vector2d(50, 160), vector2d(70, 80), red)
image.triangle(vector2d(180, 50), vector2d(150, 1), vector2d(70, 180), white)
image.triangle(vector2d(180, 150), vector2d(120, 160), vector2d(130, 180),
               green)

when false:
  var head = newModel("african_head.obj")
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

