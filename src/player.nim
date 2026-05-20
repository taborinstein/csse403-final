import
    nimgame2 / [
        assets,
        graphic,
        input,
        nimgame,
        entity
    ],
    data

const
    Speed = 750.0 # pixels per second

type
    Player* = ref object of Entity
        radius: float

proc init*(player: Player) = 
    player.initEntity()
    player.graphic = gfxData["player"]
    player.radius = player.graphic.dim.w / 2
    player.centrify()
    player.collider = player.newCircleCollider((0.0,0.0), player.radius) 
    
    player.tags.add("player")
#     player.collider.tags.add("player")
    player.physics = platformerPhysics
#     player.acc.y = 1000

proc newPlayer*(): Player =
    new result
    init result

method update*(player: Player, elapsed: float) = 
    player.updateEntity(elapsed)
    if ScancodeUp.down or ScanCodeW.down: 
        player.vel.y = -Speed
    elif ScancodeDown.down or ScancodeS.down: 
        player.vel.y = Speed
    else:
        player.vel.y = 0
    if ScancodeLeft.down or ScancodeA.down: 
        player.vel.x = -Speed
    elif ScancodeRight.down or ScanCodeD.down: 
        player.vel.x = Speed
    else:
        player.vel.x = 0

method onCollide*(player: Player, target: Entity) =
    
    discard

method handleCollideWithEnemy*(player: Player) = 
    
