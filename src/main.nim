import
  nimgame2 / [
    input,
    scene,
    types,
    entity,
    nimgame,
    settings,
    textgraphic
  ],
  data,
  player
import levels, maze_creation, key, door, enemy
import std/strformat

# type
#     Level = tilemap: ref object of TileMap
type
  MainScene = ref object of Scene
    player: Player
    level: Level
    maze: MazeSpec
    keys: seq[Key]
    num_keys_has: int
    player_lives: int

proc init*(scene: MainScene) =
    init Scene(scene)
    scene.maze = levels.levels[0]
    scene.player = newPlayer()
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
    
    scene.player_lives = 3

    
    let ui = newTextGraphic(bigFont)
    ui.setText " Keys: 0"
    ui.color = toColor(0x888888ffu32)
    let title = newEntity()
    title.layer = 100
    title.graphic = ui
    for k in scene.maze.keys:
        let key = newKey()
        key.pos = k * (128.0, 128.0) + (64.0, 64.0)
        scene.keys.add key
        key.layer = 9
        key.on_collect = proc() =
            scene.num_keys_has += 1
            ui.setText &" Keys: {scene.num_keys_has}"
    for key in scene.keys:
        key.parent = scene.camera
        scene.add key
    
    for d in scene.maze.doors:
        let door = newDoor() 
        door.pos = d * (128.0, 128.0) + (64.0, 64.0)
        door.parent = scene.camera
        scene.player.collisionEnvironment.add door
        door.sensor.can_unlock = proc(): bool = 
            if scene.num_keys_has > 0:
                scene.num_keys_has -= 1
                ui.setText &" Keys: {scene.num_keys_has}"
                return true
            return false
        scene.add door.sensor
        scene.add door
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
