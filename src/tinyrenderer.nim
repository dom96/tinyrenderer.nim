import tgaimage

proc line(image: var TGAImage, x0, y0, x1, y1: int, color: TGAColor) =
  for t in countup(0.0, 1.0, 0.01):
    let x = x0.float * (1.0 - t) + x1.float * t
    let y = y0.float * (1.0 - t) + y1.float * t
    doAssert image.set(x.cint, y.cint, color)

let
  white = constructTGAColor(255, 255, 255, 255)
  red = constructTGAColor(255, 0, 0, 255)

var image = constructTGAImage(100, 100, RGB.cint)
image.line(13, 20, 80, 40, white)
doAssert image.flipVertically()
doAssert image.writeTgaFile("output.tga")

