import
    nimgame2 / [
        assets,
        graphic,
        input,
        nimgame,
        entity,
        types
    ],
    data,
    main

type
    Key* = ref object of Entity
        radius: float
        on_collect*: proc(): void

proc init*(key: Key) = 
    key.initEntity()
    key.graphic = gfxData["key"]
    key.radius = key.graphic.dim.w / 2
    key.centrify()
    key.collider = key.newCircleCollider((0.0,0.0), key.radius) 
    key.tags.add("key")

proc newKey*(): Key =
    new result
    init result

method onCollide*(key: Key, target: Entity) =
    key.on_collect()
    key.dead = true