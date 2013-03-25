class @Map
    FLOOR: '.'
    WALL: '#'

    constructor: (dim) ->
        @cells = {}
        @height = dim.height
        @width = dim.width
        new MapGenerators.RandomMap(@).generate()

    toKey       : (p) -> "#{p.x},#{p.y}"
    get         : (p) -> @cells[@toKey p]
    set         : (p, val) -> @cells[@toKey p] = val
    empty       : (p) -> @set p, false
    fill        : (p) -> @set p, true
    outOfBounds : (p) -> [p.x, p.y] not of @cells
    isWall      : (p) -> @get(p) is true
    isBlocked   : (p) -> @outOfBounds(p) or @isWall(p)
    charAt      : (p) -> if @isWall(p) then @WALL else @FLOOR
    points      : -> @toPoint key for key in Object.keys @cells
    toPoint     : (key) ->
        [x,y] = key.split(",")
        {x: parseInt(x), y: parseInt(y)}
