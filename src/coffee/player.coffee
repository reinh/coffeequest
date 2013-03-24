class @Actor
    constructor: (@x, @y, @engine) ->
    char: '*'
    damage: 3
    hp: 10
    dead: false
    draw: -> Backbone.trigger 'set', {x:@x, y:@y}, @char
    attack: (actor) ->
        actor.hit @damage
        console.log "Attacking", actor.char, "for", @damage, "damage"
        console.log actor.char, "is dead!" if actor.dead
    hit: (damage) -> @dead = (@hp -= damage) <= 0
    act: -> console.log @.char, "acting"

class @Random extends Actor
    char: '%'
    act: (turn) ->
        super
        dir = [_.random(-1, 1), _.random(-1, 1)]
        Backbone.trigger 'move', @, dir...
        turn.end()

class @Player extends Actor
    char: '@'

    act: (turn) ->
        super
        turn.context.one 'keyup', (e) =>
            dir = switch e.which
                when Keys.H then [-1,  0]
                when Keys.J then [ 0,  1]
                when Keys.K then [ 0, -1]
                when Keys.L then [ 1,  0]
                else null

            if dir?
                Backbone.trigger 'move', @, dir...
                turn.end()
            else
                turn.redo()
