import math

import tgaimage, model

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
      doAssert image.set(y.cint, x.cint, color)
    else:
      doAssert image.set(x.cint, y.cint, color)

let
  white = constructTGAColor(255, 255, 255, 255)
  red = constructTGAColor(255, 0, 0, 255)


const
  width = 1000
  height = 1000
var image = constructTGAImage(width, height, RGB.cint)
var head = newModel("african_head.obj")

for i in 0 .. <head.nfaces():
  let face = head.face(i)
  for j in 0 .. <3:
    let v0 = head.vert(face[j])
    let v1 = head.vert(face[j+1] mod 3)

    let x0 = (v0.x+1.0) * width/2
    let y0 = (v0.y+1.0) * height/2
    let x1 = (v1.x+1.0) * width/2
    let y1 = (v1.y+1.0) * height/2
    image.line(x0.cint, y0.cint, x1.cint, y1.cint, white)

doAssert image.flipVertically()
doAssert image.writeTgaFile("output.tga")

