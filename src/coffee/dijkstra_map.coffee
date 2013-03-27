class @DijkstraMap extends @Grid
    @cache: LRUCache(50)

    constructor: (@map, @goals) ->
        super
        # count updates to prevent spinning
        @updates = 0

        @set point, Infinity for point in @map.points() when @map.isFloor(point)
        @set goal, 0 for goal in @goals

        @calculate()

    hash: ->
        goalStr = (_.map @goals, (g) -> "[#{g.x},#{g.y}]").join(",")
        "#{@map.id}-#{goalStr}"

    charAt: (p) -> "#{@get p}"

    calculate: ->
        key = @hash()
        if DijkstraMap.cache.has key
            _.debug "cache hit:  #{key}"
            @cells = DijkstraMap.cache.get key
        else
            _.debug "cache miss: #{key}"
            @update()
            DijkstraMap.cache.set key, @cells

    update: ->
        @updates++
        old = _.extend({}, @cells)
        @updateCell point for point in @points()
        @update() unless _.isEqual(old, @cells) or @updates > 1000

    updateCell: (point) ->
        value = @get point
        return unless value is Infinity
        neighbors = @neighbors(point)

        lowest_neighbor_value = _.min(_.map neighbors, (n) => @get n)

        if value - 2 > lowest_neighbor_value
            @set point, lowest_neighbor_value + 1

    neighbors: (cell) ->
        possibles = for a in _.product [-1..1], [-1..1]
            p = _.toPoint a
            {x: p.x + cell.x, y: p.y + cell.y}

        _.reject possibles, (point) =>
            originalCell = point.x is cell.x and point.y is cell.y
            originalCell or @outOfBounds point

