import
  nimgame2 / [
    scene,
  ],
  data,
  player

type
  MainScene = ref object of Scene
    player: Player

proc init*(scene: MainScene) =
  init Scene(scene)
  
  scene.player = newPlayer()
  scene.add(scene.player)

proc newMainScene*(): MainScene =
  new(result)
  init result

method show*(scene: MainScene) =
  echo "Switched to MainScene"