{.compile: "tgaimage.cpp".}

type
  TGA_Header* {.importcpp: "TGA_Header", header: "tgaimage.h".} = object
    idlength* {.importc: "idlength".}: char
    colormaptype* {.importc: "colormaptype".}: char
    datatypecode* {.importc: "datatypecode".}: char
    colormaporigin* {.importc: "colormaporigin".}: cshort
    colormaplength* {.importc: "colormaplength".}: cshort
    colormapdepth* {.importc: "colormapdepth".}: char
    x_origin* {.importc: "x_origin".}: cshort
    y_origin* {.importc: "y_origin".}: cshort
    width* {.importc: "width".}: cshort
    height* {.importc: "height".}: cshort
    bitsperpixel* {.importc: "bitsperpixel".}: char
    imagedescriptor* {.importc: "imagedescriptor".}: char

  TGAColor* {.importcpp: "TGAColor", header: "tgaimage.h".} = object
    bytespp* {.importc: "bytespp".}: cint

  INNER_C_STRUCT_2915824551* {.importcpp: "no_name", header: "tgaimage.h".} = object
    b* {.importc: "b".}: cuchar
    g* {.importc: "g".}: cuchar
    r* {.importc: "r".}: cuchar
    a* {.importc: "a".}: cuchar


proc constructTGAColor*(): TGAColor {.constructor, importcpp: "TGAColor(@)",
                                   header: "tgaimage.h".}
proc constructTGAColor*(R: cint; G: cint; B: cint; A: cint): TGAColor {.
    constructor, importcpp: "TGAColor(@)", header: "tgaimage.h".}
proc constructTGAColor*(v: cint; bpp: cint): TGAColor {.constructor,
    importcpp: "TGAColor(@)", header: "tgaimage.h".}
proc constructTGAColor*(c: TGAColor): TGAColor {.constructor,
    importcpp: "TGAColor(@)", header: "tgaimage.h".}
proc constructTGAColor*(p: ptr cuchar; bpp: cint): TGAColor {.constructor,
    importcpp: "TGAColor(@)", header: "tgaimage.h".}
type
  TGAImage* {.importcpp: "TGAImage", header: "tgaimage.h", final.} = object
  
  Format* {.size: sizeof(cint), importcpp: "TGAImage::Format", header: "tgaimage.h".} = enum
    GRAYSCALE = 1, RGB = 3, RGBA = 4


proc constructTGAImage*(): TGAImage {.constructor, importcpp: "TGAImage(@)",
                                   header: "tgaimage.h".}
proc constructTGAImage*(w: cint; h: cint; bpp: cint): TGAImage {.constructor,
    importcpp: "TGAImage(@)", header: "tgaimage.h".}
proc constructTGAImage*(img: TGAImage): TGAImage {.constructor,
    importcpp: "TGAImage(@)", header: "tgaimage.h".}
proc read_tga_file*(this: var TGAImage; filename: cstring): bool {.
    importcpp: "read_tga_file", header: "tgaimage.h".}
proc write_tga_file*(this: var TGAImage; filename: cstring; rle: bool = true): bool {.
    importcpp: "write_tga_file", header: "tgaimage.h".}
proc flip_horizontally*(this: var TGAImage): bool {.importcpp: "flip_horizontally",
    header: "tgaimage.h".}
proc flip_vertically*(this: var TGAImage): bool {.importcpp: "flip_vertically",
    header: "tgaimage.h".}
proc scale*(this: var TGAImage; w: cint; h: cint): bool {.importcpp: "scale",
    header: "tgaimage.h".}
proc get*(this: var TGAImage; x: cint; y: cint): TGAColor {.importcpp: "get",
    header: "tgaimage.h".}
proc set*(this: var TGAImage; x: cint; y: cint; c: TGAColor): bool {.importcpp: "set",
    header: "tgaimage.h".}
proc destroyTGAImage*(this: var TGAImage) {.importcpp: "#.~TGAImage()",
                                        header: "tgaimage.h".}
proc get_width*(this: var TGAImage): cint {.importcpp: "get_width",
                                       header: "tgaimage.h".}
proc get_height*(this: var TGAImage): cint {.importcpp: "get_height",
                                        header: "tgaimage.h".}
proc get_bytespp*(this: var TGAImage): cint {.importcpp: "get_bytespp",
    header: "tgaimage.h".}
proc buffer*(this: var TGAImage): ptr cuchar {.importcpp: "buffer", header: "tgaimage.h".}
proc clear*(this: var TGAImage) {.importcpp: "clear", header: "tgaimage.h".}