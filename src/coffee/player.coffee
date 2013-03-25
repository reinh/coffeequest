class @Actor
    constructor: (@x, @y) ->
    name: 'the beastie'
    char: '*'
    damage: 3
    hp: 10
    dead: false
    at: (p) ->
        return false if @dead
        p.x is @x and p.y is @y

    attack: (actor) -> actor.hit @damage
    hit: (damage) -> @dead = (@hp -= damage) <= 0
    act: (turn) -> turn.end()

class @Random extends Actor
    char: '%'
    act: (turn) ->
        dir = [_.random(-1, 1), _.random(-1, 1)]
        Backbone.trigger 'move', @, dir...
        turn.end()

class @Player extends Actor
    char: '@'
    name: 'the Hero'

    act: (turn) ->
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
