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

proc init*(enemy: Enemy, speed: float, graphicName: string, radius: int) = 
    enemy.initEntity()
    enemy.speed = speed
    enemy.graphic = gfxData[graphicName]
    
    enemy.tags.add("enemy")
    enemy.physics = platformerPhysics

# stationary enemy... 
proc newEnemy1(): Enemy =
    var enemy = new Enemy
    init enemy, 0, "enemy1", 32
    enemy.initSprite((30,30))
    discard enemy.addAnimation("flash", [0,1], 1/2)
    enemy.play("flash", -1)
    enemy.centrify()
    enemy.collider = enemy.newCircleCollider((0.0,0.0), enemy.radius) 
    return enemy

proc newEnemy2(): Enemy = 
    return newEnemy1()

proc newEnemy*(enemyType: int): Enemy =
    var enemy = new Enemy
    case enemyType:
        of 1:
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
