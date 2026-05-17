import
  nimgame2 / [
    assets,
    scene,
    font,
    truetypefont,
    types,
    texturegraphic,
  ]

const
  GameWidth* = 640
  GameHeight* = 360
  GameTitle* = "Maze Game"


var
  titleScene*, mainScene*: Scene
  defaultFont*, bigFont*: TrueTypeFont
  gfxData*: Assets[TextureGraphic]
  
proc loadData*() =
  defaultFont = newTrueTypeFont()
  if not defaultFont.load("data/fnt/FSEX302.ttf", 16):
    echo "ERROR: Can't load default font"
  bigFont = newTrueTypeFont()
  if not bigFont.load("data/fnt/FSEX302.ttf", 32):
    echo "ERROR: Can't load big font"
  
  gfxData = newAssets[TextureGraphic](
    "data/gfx",
    proc(file: string): TextureGraphic = newTextureGraphic(file))

proc freeData*() = 
  defaultFont.free()
  bigFont.free()
  for graphic in gfxData.values:
    graphic.free()