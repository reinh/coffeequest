class World
    constructor: (@dimensions) ->
        @map = new Map(@dimensions)
        @player = new Player(0,0)

    redraw: (x, y) -> @map.redraw x, y
    isBlocked: (x, y) -> @map.isBlocked x, y

@World = World
