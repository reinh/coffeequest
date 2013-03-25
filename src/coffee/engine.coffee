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

        @player    = new Player(0,0)
        @actors    = [@player, new Actor(2, 2)]
        @messages  = []
        @scheduler = new Scheduler(@actors)

        Backbone.on 'move', (args...) => @move args...
        Backbone.on 'message', (message, important) =>
            message = { text: message } if typeof message is "string"
            message.id = _.uniqueId 'message'
            message.important ?= important
            @messages.push message
            @messages = _.last @messages, 100

        @display = new Display(@)

    run: =>
        @display.update(@)
        new Turn(@, @scheduler.next()).run()

    move: (actor, dx, dy) =>
        newPoint = {x: actor.x+dx, y: actor.y+dy}
        target = _.find @actors, (actor) -> actor.at(newPoint)

        switch
            when target
                who = if actor is @player then 'You' else actor.char
                what = "attack#{if actor is @player then '' else 's'}"
                whom = target.name

                message = { text: "" }

                actor.attack target
                if target.isAlive()
                    message.text += "#{who} #{what} #{whom}."
                    if target.isHurt()
                        message.text += " It is badly injured!"
                else
                    @actors = _.difference @actors , [target]
                    message.text += "#{who} kill #{whom}!"
                    message.important = true
                Backbone.trigger 'message', message
            when @world.isBlocked newPoint
                Backbone.trigger 'message', 'You are blocked!' if actor is @player
            else
                _.extend(actor, newPoint)
