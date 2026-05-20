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
    DoorSensor* = ref object of Entity

type
    Door* = ref object of Entity
        radius: float
        sensor*: DoorSensor

proc init*(sensor: DoorSensor) =
    sensor.initEntity()
    sensor.collider = sensor.newBoxCollider(sensor.pos, (148.0,148.0))
    sensor.tags.add("door_sensor")
    sensor.centrify()

proc init*(door: Door) = 
    door.sensor = new DoorSensor
    door.sensor.init

    door.initEntity()
    door.graphic = gfxData["door"]
    door.radius = door.graphic.dim.w / 2
    door.centrify()
    door.collider = door.newBoxCollider(door.pos, (door.graphic.w, door.graphic.h) )
    # door.sensor = door.newBoxCollider(door.pos, (148.0, 148.0) )
    door.tags.add("door")

proc newDoor*(): Door =
    new result
    init result

method update*(sensor: DoorSensor, elapsed: float) = 
    sensor.collider.renderCollider
    echo "sensor update"

method update*(door: Door, elapsed: float) = 
    door.collider.renderCollider
    echo "door update"
    # echo door.sensor.isColliding()

method onCollide(door: Door, target: Entity) = 
    discard
    # echo target.tags