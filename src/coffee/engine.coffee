class @Scheduler
    constructor: (@items) -> @index = 0

    next: ->
        item = @items[@index]
        @index++
        @index = 0 if @index >= @items.length
        return item

class @Engine
    constructor: (@world, @context) ->
        {height: height, width: width} = @world.dimensions

        Backbone.on 'move', (args...) => @move args...

        @player    = new Player(0,0)
        @actors    = [@player, new Random(10,10, @)]
        @display   = new Display(@)
        @scheduler = new Scheduler(@actors)

    run: =>
        @display.update()
        new Turn(@, @scheduler.next()).run()

    move: (actor, dx, dy) =>
        newPoint = {x: actor.x+dx, y: actor.y+dy}
        _.extend(actor, newPoint) unless @world.isBlocked newPoint

