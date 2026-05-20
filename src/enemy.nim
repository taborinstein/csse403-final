import
    nimgame2 / [
        assets,
        graphic,
        input,
        nimgame,
        entity
    ],
    data

# const
#     Speed = 750.0 # pixels per second

type
    Enemy* = ref object of Entity
        radius: float
	speed: float
	updateSelf*: proc (enemy: Enemy, elapsed: float)

proc init*(enemy: Enemy, speed, graphicName: string) = 
    enemy.initEntity()
    enemy.speed = speed
    enemy.graphic = gfxData[graphicName]
    enemy.radius = enemy.graphic.dim.w / 2
    enemy.centrify()
    enemy.collider = enemy.newCircleCollider((0.0,0.0), enemy.radius) 
    
    enemy.tags.add("enemy")
    enemy.physics = platformerPhysics

# stationary enemy... 
proc newEnemy1*(): Enemy =
    new result
    init result, 0, "enemy1"

method update*(enemy: Enemy, elapsed: float) = 
    enemy.updateEntity(elapsed)
    enemy.updateSelf(elapsed)
    

method onCollide*(player: Player, target: Entity) =
    # collision with player  
    if "player" in target.tags:
	player.handleCollideWithEnemy()
