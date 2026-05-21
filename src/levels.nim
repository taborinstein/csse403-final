import
    nimgame2 / [
    entity,
    texturegraphic,
    tilemap,
    ]
import maze_creation
import level_data/[
    level_1,
    level_2,
    level_3,
    level_4,
    level_5,
    level_6,
]

let levels* = [
    level_1.level_1,
    level_2.level_2,
    level_3.level_3,
    level_4.level_4,
    level_5.level_5,
    level_6.level_6,
]


const
    TileDim* = (128,128)


type
    Level* = ref object of TileMap
        # maze: MazeSpec


proc init*(level: Level, tiles: TextureGraphic) =
    init Tilemap level
    level.tags.add("level")
    level.graphic = tiles
    level.initSprite(TileDim)


proc newLevel*(tiles: TextureGraphic): Level =
    new result
    result.init(tiles)


proc load*(level: Level, maze: MazeSpec) =
    level.map = @[]#@[@[0],@[0],@[1]]
    for i in 0..<maze.height:
        level.map.add newSeq[int](maze.width)
    # level.map[0][0] = 1
    for wall in maze.walls:
        level.map[wall.y.toInt][wall.x.toInt] = 1
    # for door in maze.doors:
    #     level.map[door.y.toInt][door.x.toInt] = 2
    level.hidden.add @[0]  # tiles on the third row are invisible markers
    level.passable.add @[0] # tiles without colliders
    level.onlyReachableColliders = true # do not init unreachable colliders
    level.initCollider()
