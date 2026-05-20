import
    nimgame2 / [
        assets,
        graphic,
        input,
        entity,
        types
    ],
    data

type
    DoorSensor* = ref object of Entity
        can_unlock*: proc(): bool

type
    Door* = ref object of Entity
        sensor*: DoorSensor


proc init*(sensor: DoorSensor) =
    sensor.initEntity()
    sensor.collider = sensor.newBoxCollider((74.0,74.0), (148.0,148.0))
    sensor.graphic = gfxData["sensor"]
    sensor.tags.add("door_sensor")
    sensor.centrify()

proc init*(door: Door) = 
    door.sensor = new DoorSensor
    door.sensor.init
    door.sensor.parent = door

    door.initEntity()
    door.graphic = gfxData["door"]
    door.centrify()
    door.collider = door.newBoxCollider(door.pos, (door.graphic.w, door.graphic.h) )
    # door.sensor = door.newBoxCollider(door.pos, (148.0, 148.0) )
    door.tags.add("door")

proc newDoor*(): Door =
    new result
    init result

method update*(sensor: DoorSensor, elapsed: float) = 
    sensor.collider.renderCollider

method update*(door: Door, elapsed: float) = 
    door.collider.renderCollider

method onCollide(sensor: DoorSensor, target: Entity) = 
    if "player" in target.tags:
        if sensor.can_unlock():
            sensor.parent.pos += (10000.0,10000.0)
            sensor.parent.dead = true
    