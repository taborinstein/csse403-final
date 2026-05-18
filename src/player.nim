import
  nimgame2 / [
    assets,
    graphic,
    input,
    nimgame,
    entity,
  ],
  data

const
  Speed = 250.0 # pixels per second

type
  Player* = ref object of Entity
    radius: float

proc init*(player: Player) = 
  player.initEntity()
  player.graphic = gfxData["player"]
  player.radius = player.graphic.dim.w / 2
  player.centrify()

  player.tags.add("player")
  player.collider = player.newCircleCollider((0, 0), player.radius)
  player.collider.tags.add("player")

proc newPlayer*(): Player =
  new result
  init result

method update*(player: Player, elapsed: float) = 
  var movement = Speed * elapsed

  if ScancodeW.down: player.pos.y -= movement
  if ScancodeS.down: player.pos.y += movement
  if ScancodeA.down: player.pos.x -= movement
  if ScancodeD.down: player.pos.x += movement

  player.pos.x = clamp(
    player.pos.x,
    player.center.x,
    game.size.w.float - player.center.x
  )
  player.pos.y = clamp(
    player.pos.y,
    player.center.y,
    game.size.h.float - player.center.x
  )