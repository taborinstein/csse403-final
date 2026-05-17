import
  nimgame2 / [
    nimgame,
    scene,
    types
  ],
  data

type
  TitleScene = ref object of Scene

proc init*(scene: TitleScene) =
  init Scene(scene)

proc newTitleScene*(): TitleScene =
  new(result)
  # new(free)
  init result

method event*(scene: TitleScene, event: Event) =
  if event.kind == KeyDown:
    game.scene = mainScene