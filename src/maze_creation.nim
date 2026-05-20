import std/macros
import std/strformat
import nimgame2/types

type 
    MazeSpec* = object
        walls*: seq[Coord]
        keys*: seq[Coord]
        doors*: seq[Coord]
        width*: int
        height*: int
        goal*: Coord
        start*: Coord

macro define_maze*(body: untyped): untyped =
    var walls: seq[Coord] = @[]
    var keys: seq[Coord] = @[]
    var key_nodes: seq[NimNode] = @[]
    var doors: seq[Coord] = @[]
    var door_nodes: seq[NimNode] = @[]
    var w = 0
    var h = body.len
    var goal: Coord = (x: 0, y: 0)
    var start: Coord = (x: 0, y: 0)
    var test: seq[string] = @[]
    for y, list in body:
        var x = 0
        test.add list.treeRepr
        # for node_group in list:
        proc iter(node: NimNode): void = 
            if node.len < 1:
                w = max(w, x)
                let pos = (x: x.toFloat, y: y.toFloat)
                case node.strVal:
                of "w":
                    walls.add(pos)
                of "K":
                    keys.add(pos)
                    key_nodes.add node
                of "D":
                    doors.add(pos)
                    door_nodes.add node
                of "X":
                    goal = pos
                of "S":
                    start = pos
                of "-":
                    discard
                else:
                    error(&"Invalid token {node.strVal} in maze", node)
                x += 1
            else:
                # discard
                case node.kind:
                of nnkInfix:
                    iter(node[1])
                    iter(node[0])
                    iter(node[2])
                of nnkPrefix, nnkCommand:
                    iter(node[0])
                    iter(node[1])
                else:
                    error(&"No idea how you got here; got node type {$node.kind}")
        iter(list) 
    w += 1
    if keys.len > doors.len:
        warning("More keys than doors", key_nodes[key_nodes.high])
    if doors.len > keys.len:
        error("More doors than keys", door_nodes[door_nodes.high])
    result = quote do:
        MazeSpec(
            walls: `walls`, 
            keys: `keys`, 
            doors: `doors`, 
            goal: `goal`,
            start: `start`,
            width: `w`,
            height: `h`
        )