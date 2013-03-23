class Player
    constructor: (@x, @y) ->
        @char = '@'

    draw: -> Backbone.trigger 'set', @x, @y, @char

@Player = Player
