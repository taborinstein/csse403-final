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
import levels, maze_creation, key, door, enemy, goal
import std/strformat

# type
#     Level = tilemap: ref object of TileMap
type
  MainScene = ref object of Scene
    player: Player
    level: Level
    maze: MazeSpec
    maze_index: int
    keys: seq[Key]
    num_keys_has: int
    player_lives: int

proc init*(scene: MainScene) =
    init Scene(scene)
    scene.maze = levels.levels[scene.maze_index]
    scene.player = newPlayer()
    scene.add(scene.player)

    scene.camera = newEntity()
    scene.player.parent = scene.camera
    scene.cameraBond = scene.player
    scene.cameraBondOffset = game.size / 2
    scene.level = newLevel(gfxData["test_rect"])
    scene.level.layer = 0
    scene.level.parent = scene.camera
    scene.level.load(scene.maze)
    scene.player.collisionEnvironment = @[Entity(scene.level)]
    scene.player.layer = 10
    scene.add scene.level
    scene.player.pos = scene.maze.start * (128.0, 128.0) + (64.0, 64.0)
    
    scene.player_lives = 3
    let lives_text = newTextGraphic(bigFont)
    lives_text.color = toColor(0x888888ffu32)
    lives_text.setText &" Lives: {scene.player_lives}"
    let lives_entity = newEntity()
    lives_entity.layer = 101
    lives_entity.graphic = lives_text
    lives_entity.pos = (0, 32)
    scene.add lives_entity

    scene.player.subtract_lives = proc() = 
        scene.player_lives -= 1
        lives_text.setText &" Lives: {scene.player_lives}"
        if scene.player_lives <= 0:
            let newScene = new MainScene 
            newScene.init()
            newScene.mazeIndex = scene.mazeIndex
            game.scene = newScene

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
    let goal = newGoal()
    goal.pos = scene.maze.goal * (128.0, 128.0) + (64.0, 64.0)
    goal.parent = scene.camera
    scene.add goal
    scene.add title

    for (e_pos, e_type) in scene.maze.enemies:
        echo "heres an enemy"
        let enemy = newEnemy(e_type)
        enemy.pos = e_pos * (128.0, 128.0) + (64.0, 64.0)
        enemy.parent = scene.camera
        scene.add enemy

    goal.on_collide = proc(): void =
        let new_scene = new MainScene
        new_scene.maze_index = scene.maze_index + 1
        new_scene.init()
        game.scene = new_scene
    
    
proc newMainScene*(index: int): MainScene =
    new result
    result.maze_index = index
    init result
proc newMainScene*(): MainScene =
    result = newMainScene(0)

method show*(scene: MainScene) =
    echo "Switched to MainScene"

method update*(scene: MainScene, elapsed: float) =
    scene.updateScene(elapsed)

    if ScancodeF1.pressed: colliderOutline = not colliderOutline
    if ScancodeF2.pressed: showInfo = not showInfo
