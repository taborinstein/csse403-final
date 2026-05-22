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

proc init*(enemy: Enemy, speed: float) = 
    enemy.initEntity()
    enemy.speed = speed
    
    enemy.tags.add("enemy")
    enemy.physics = platformerPhysics

proc addFlashingKeySprite(enemy: Enemy) =
    enemy.radius = 32
    enemy.graphic = gfxData["enemy1"]
    enemy.initSprite((30,30))
    discard enemy.addAnimation("flash", [0,1], 1/2)
    enemy.play("flash", -1)
    enemy.centrify()
    enemy.collider = enemy.newCircleCollider((0.0,0.0), enemy.radius) 

# stationary enemy... 
proc newEnemy1(): Enemy =
    var enemy = new Enemy
    init enemy, 0 
    enemy.addFlashingKeySprite()
    enemy.updateSelf = proc(enemy: Enemy, elapsed:float) = discard
    return enemy

# left right
proc newEnemy2(): Enemy = 
    var enemy = new Enemy
    init enemy, 1024
    enemy.addFlashingKeySprite()
    enemy.vel.x = -enemy.speed
    enemy.updateSelf = proc(enemy: Enemy, elapsed:float) = 
        enemy.time_since_action += elapsed
        if enemy.time_since_action >= 1:
            enemy.time_since_action = 0
            enemy.vel.x = -enemy.vel.x
    return enemy

# up down
proc newEnemy3(): Enemy = 
    var enemy = new Enemy
    init enemy, 1024
    enemy.addFlashingKeySprite()
    enemy.vel.y = -enemy.speed
    enemy.updateSelf = proc(enemy: Enemy, elapsed:float) = 
        enemy.time_since_action += elapsed
        if enemy.time_since_action >= 1:
            enemy.time_since_action = 0
            enemy.vel.y = -enemy.vel.y
    return enemy


proc newEnemy4(): Enemy =
    return newEnemy3()

proc newEnemy*(enemyType: int): Enemy =
    var enemy = new Enemy
    case enemyType:
        of 1:
            enemy = newEnemy1()
        of 2: 
            enemy = newEnemy2()
        of 3:
            enemy = newEnemy3()
        of 4:
            enemy = newEnemy4()
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
