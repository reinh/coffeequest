class @Turn
    constructor: (@engine, @actor) ->
        @context = $(window)
        @promise = $.Deferred()

        @promise.fail @retry
        @promise.done @finish

    end: -> @promise.resolve()
    redo: -> @promise.reject()

    run: => @actor.act @
    retry: => new Turn(@engine, @actor).run()
    finish: =>
        @actor.draw()
        @engine.run()
