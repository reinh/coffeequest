class @Scheduler
    constructor: (@items) -> @index = 0

    next: ->
        item = @items[@index]
        @index++
        @index = 0 if @index >= @items.length
        return item

class Engine
    constructor: (@world, @context) ->
        {height: height, width: width} = @world.dimensions
        @player = @world.player

        @display = new Display(rows: height, columns: width)
        Backbone.on 'move', (args...) => @move args...

        actors = [@player, new Random(10,10, @)]
        @scheduler = new Scheduler(actors)

        actor.draw() for actor in actors
        @display.render()
        $.when(@display.el.focus).then @run

    run: =>
        @display.render()
        actor = @scheduler.next()
        act = =>
            turn = $.Deferred()
            turn.context = $(window)
            turn.always -> actor.draw()
            turn.done @run
            turn.fail act

            actor.act turn
        act()

    move: (actor, dx, dy) =>
        [x,y] = [actor.x+dx, actor.y+dy]

        unless @world.isBlocked x, y
            @display.set x, y, actor.char
            @world.redraw actor.x, actor.y
            actor.x = x
            actor.y = y

@Engine = Engine
