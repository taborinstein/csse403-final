import std/macros
import std/strformat
import nimgame2/types

type 
    MazeSpec* = object
        walls: seq[Coord]
        keys: seq[Coord]
        doors: seq[Coord]
        goal: Coord

macro define_maze*(body: untyped): untyped =
    var walls: seq[Coord] = @[]
    var keys: seq[Coord] = @[]
    var doors: seq[Coord] = @[]
    var goal: Coord = (x: 0, y: 0)
    for y, list in body:
        var x = 0
        for node_group in list:
            proc iter(node: NimNode): void = 
                if node.len < 1:
                    let pos = (x: x.toFloat, y: y.toFloat)
                    case node.strVal:
                    of "w":
                        walls.add(pos)
                    of "K":
                        keys.add(pos)
                    of "D":
                        doors.add(pos)
                    of "X":
                        doors.add(pos)
                    of "S":
                        goal = pos
                    of "-":
                        discard
                    else:
                        error(&"Invalid token {node.strVal} in maze", node)
                    x += 1
                for sub_node in node:
                    iter(sub_node)
            iter(node_group) 
    result = quote do:
        MazeSpec(walls: `walls`, keys: `keys`, doors: `doors`, goal: `goal`)
