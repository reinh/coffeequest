class World
    constructor: (@dimensions) ->
        @map = new Map(@dimensions)

    paint: (display) ->
        for row in [0...@dimensions.height]
            for col in [0...@dimensions.width]
                point = {x:col, y:row}
                display.set point, @charAt point

    charAt: (point) -> @map.charAt point
    isBlocked: (x, y) -> @map.isBlocked x, y

@World = World
