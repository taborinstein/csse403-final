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
        time_since_action: float
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

# left right
proc newEnemy2(): Enemy = 
    var enemy = new Enemy
    init enemy, 750, "enemy1", 32
    enemy.initSprite((30,30))
    enemy.centrify()
    enemy.collider = enemy.newCircleCollider((0.0,0.0), enemy.radius)
    enemy.vel.x = -enemy.speed
    return enemy

proc newEnemy*(enemyType: int): Enemy =
    var enemy = new Enemy
    case enemyType:
        of 1:
            enemy = newEnemy1()
            enemy.updateSelf = proc(enemy: Enemy, elapsed:float) = discard
        of 2: 
            enemy = newEnemy2()
            enemy.updateSelf = proc(enemy: Enemy, elapsed:float) = 
                enemy.time_since_action += elapsed
                if enemy.time_since_action >= 2:
                    enemy.time_since_action = 0
                    enemy.vel.x = -enemy.vel.x
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
