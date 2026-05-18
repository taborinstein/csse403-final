import
  nimgame2 / [
    assets,
    graphic,
    input,
    nimgame,
    entity,
    types
  ],
  data

type
  TestWall* = ref object of Entity

proc init*(wall: TestWall, pos: Coord) =
  wall.initEntity()
  wall.graphic = gfxData["test_rect"]
  wall.pos = pos

  wall.tags.add("wall")
  let
    centerX = pos[0] + 20
    centerY = pos[1] + 20
  wall.collider = wall.newBoxCollider((centerX, centerY), (40, 40))
  wall.collider.tags.add("wall")

proc newTestWall*(pos: Coord): TestWall =
  new result
  init(result, pos)