class @Map extends @Grid
    FLOOR: '.'
    WALL: '#'

    constructor: (dim) ->
        super
        @id = _.uniqueId 'map'
        @height = dim.height
        @width = dim.width
        new MapGenerators.RandomMap(@).generate()

    empty       : (p) -> @set p, false
    fill        : (p) -> @set p, true
    isWall      : (p) => @get(p) is true
    isFloor     : (p) => @get(p) is false
    isBlocked   : (p) -> @outOfBounds(p) or @isWall(p)
    charAt      : (p) -> if @isWall(p) then @WALL else @FLOOR
