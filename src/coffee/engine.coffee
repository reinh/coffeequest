class Engine
    constructor: (@world, @context) ->
        {height: height, width: width} = @world.dimensions
        @display = new Display(rows: height, columns: width)
        @player = @world.player
        @player.draw()
        @tick()

        @context.keyup (e) =>
            switch e.which
                when Keys.H then @move @player, -1, 0
                when Keys.J then @move @player, 0, 1
                when Keys.K then @move @player, 0, -1
                when Keys.L then @move @player, 1, 0

    move: (actor, dx, dy) =>
        [x,y] = [actor.x+dx, actor.y+dy]

        unless @world.isBlocked x, y
            @display.set x, y, actor.char
            @world.redraw actor.x, actor.y
            actor.x = x
            actor.y = y
            @tick()

    tick: ->
        @display.render()

@Engine = Engine
