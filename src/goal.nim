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
    Goal* = ref object of Entity
        radius: float
        on_collide*: proc(): void

proc init*(goal: Goal) = 
    goal.initEntity()
    goal.graphic = gfxData["goal"]
    goal.radius = goal.graphic.dim.w / 2
    goal.centrify()
    goal.collider = goal.newBoxCollider(goal.pos, (goal.graphic.w, goal.graphic.h) )
    goal.tags.add("goal")

proc newGoal*(): Goal =
    new result
    init result

method onCollide*(goal: Goal, target: Entity) =
    if "player" in target.tags:
        goal.on_collide()
        goal.dead = true