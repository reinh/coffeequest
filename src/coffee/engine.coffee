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
        @display   = new Display(rows: height, columns: width)
        actors     = [@player, new Random(10,10, @)]
        @scheduler = new Scheduler(actors)

        @world.paint @display

        for actor in actors
            @display.set actor, actor.char

    run: =>
        @display.render()
        new Turn(@, @scheduler.next()).run()

    move: (actor, dx, dy) =>
        [x,y] = [actor.x+dx, actor.y+dy]
        oldPoint = {x: actor.x, y: actor.y}
        newPoint = {x:x, y:y}

        unless @world.isBlocked newPoint
            @display.set oldPoint, @world.charAt actor
            @display.set newPoint, actor.char
            actor.x = x
            actor.y = y

