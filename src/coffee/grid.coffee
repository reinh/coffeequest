class @Grid
    constructor: -> @cells = {}

    toKey : (p) -> "#{p.x},#{p.y}"
    get   : (p) -> @cells[@toKey p]
    set   : (p, val) -> @cells[@toKey p] = val

    outOfBounds : (p) -> @toKey(p) not of @cells
    points      : -> @toPoint key for own key, _ of @cells
    toPoint     : (key) ->
        [x,y] = key.split(",")
        {x: parseInt(x), y: parseInt(y)}
