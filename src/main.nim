import
  nimgame2 / [
    input,
    scene,
    settings,
    draw,
    types,
    entity,
  ],
  data,
  player,
  test_wall

type
  MainScene* = ref object of Scene
    player: Player
    tiles: array[18, array[32, Entity]] # might have to switch dimensions

proc init*(scene: MainScene) =
  init Scene(scene)
  
  scene.player = newPlayer()
  scene.player.pos = (GameWidth / 2, GameHeight / 2)
  scene.add(scene.player)

  for i in 0..17:
    scene.tiles[i][0] = newTestWall((i * 40, 0))
  
  for row in scene.tiles:
    for e in row:
      if e != nil:
        scene.add(e)

proc newMainScene*(): MainScene =
  new result
  init result

method show*(scene: MainScene) =
  echo "Switched to MainScene"

method update*(scene: MainScene, elapsed: float) =
  scene.updateScene(elapsed)

  if ScancodeF1.pressed: colliderOutline = not colliderOutline
  if ScancodeF2.pressed: showInfo = not showInfo