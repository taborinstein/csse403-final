import
    nimgame2 / [
        assets,
        graphic,
        input,
        nimgame,
        entity
    ],
    data,
    player

# const
#     Speed = 750.0 # pixels per second

type
    Enemy* = ref object of Entity
        radius: float
        speed: float
        updateSelf*: proc (enemy: Enemy, elapsed: float)

proc init*(enemy: Enemy, speed: float, graphicName: string) = 
    enemy.initEntity()
    enemy.speed = speed
    enemy.graphic = gfxData[graphicName]
    enemy.radius = enemy.graphic.dim.w / 2
    enemy.centrify()
    enemy.collider = enemy.newCircleCollider((0.0,0.0), enemy.radius) 
    
    enemy.tags.add("enemy")
    enemy.physics = platformerPhysics

# stationary enemy... 
proc newEnemy1(): Enemy =
    new result
    init result, 0, "key"

proc newEnemy2(): Enemy = 
    return newEnemy1()

proc newEnemy*(enemyType: int): Enemy =
    var enemy = new Enemy
    case enemyType:
        of 1:
            echo "test"
            enemy =  newEnemy1()
            enemy.updateSelf = proc(enemy: Enemy, elapsed:float) = discard
        of 2: 
            return newEnemy2()
        else:
            echo "unrecognized enemy"
            return newEnemy1()
    return enemy

method update*(enemy: Enemy, elapsed: float) = 
    enemy.updateEntity(elapsed)
    enemy.updateSelf(enemy, elapsed)
    

method onCollide*(enemy: Enemy, target: Entity) =
    # collision with player  
    #if "player" in target.tags:
    #    Player(target).handleCollideWithEnemy()
    discard
