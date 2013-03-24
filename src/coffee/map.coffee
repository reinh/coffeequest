class Map
    constructor: (dim) ->
        @height = dim.height
        @width = dim.width
        for x in [0...@width]
            for y in[0...@height]
                @[[x,y]] = null

    isBlocked: (x, y) ->
        [x, y] not of @

    charAt: (point) -> @[[point.x, point.y]] or '.'

@Map = Map
