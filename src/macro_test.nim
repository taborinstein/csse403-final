import std/macros

macro maze(body: untyped): untyped =
    let a = body[0]
    result = quote do:
        let `a` = "hi this is a maze"


maze:
    lvl1
    w w w w w w w w w w w 
    w K w w w w w w w w w
    w - w - w w w - - - X
    w - - - - - - - - w w
    w w w - w w w w - w w
    E - - - - w w - - w w
    w w w w - w w w w w w
    w K - - - - - - w w w
    w w w w w w w w w w w
echo lvl1