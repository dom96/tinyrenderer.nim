import math

import tgaimage

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

var image = constructTGAImage(100, 100, RGB.cint)
image.line(13, 20, 80, 40, white)
image.line(20, 13, 40, 80, red)
image.line(80, 40, 13, 20, red)
doAssert image.flipVertically()
doAssert image.writeTgaFile("output.tga")

