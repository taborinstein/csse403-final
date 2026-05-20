import
  nimgame2 / [
    input,
    scene,
    settings,
    types,
    entity,
    nimgame,
    textgraphic,
    draw
  ],
  data,
  player
import levels, maze_creation

# type
#     Level = tilemap: ref object of TileMap
type
  MainScene* = ref object of Scene
    player: Player
    level: Level
    maze: MazeSpec

proc init*(scene: MainScene) =
    init Scene(scene)
    # scene.level = levels.levels[0]
    scene.player = newPlayer()
    scene.player.pos = (GameWidth / 2, GameHeight / 2)
    scene.add(scene.player)

    scene.camera = newEntity()
    scene.player.parent = scene.camera
    scene.cameraBond = scene.player
    scene.cameraBondOffset = game.size / 2
    scene.level = newLevel(gfxData["test_rect"])
    scene.level.layer = 0
    scene.level.parent = scene.camera
    scene.level.load
    scene.player.collisionEnvironment = @[Entity(scene.level)]
    scene.player.layer = 10
    scene.add scene.level
    scene.player.pos = levels.levels[0].start * (128.0, 128.0) + (64.0, 64.0)
    
    let ui = newTextGraphic(bigFont)
    ui.setText "Keys: 0"
    
    let title = newEntity()
    title.graphic = ui
    discard box((0, 0), (20, 20), ColorBlack)
    scene.add title
    
    
proc newMainScene*(): MainScene =
    new result
    init result

method show*(scene: MainScene) =
    echo "Switched to MainScene"

method update*(scene: MainScene, elapsed: float) =
    scene.updateScene(elapsed)

    if ScancodeF1.pressed: colliderOutline = not colliderOutline
    if ScancodeF2.pressed: showInfo = not showInfo