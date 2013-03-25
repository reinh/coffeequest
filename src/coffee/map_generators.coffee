@MapGenerators = {}

class@MapGenerators.MapGenerator
    constructor: (@map) ->

class @MapGenerators.EmptyMap extends @MapGenerators.MapGenerator
    generate: ->
        for x in [0...@map.width]
            for y in[0...@map.height]
                @map.empty x: x, y: y

class @MapGenerators.RandomMap extends @MapGenerators.MapGenerator
    generate: ->
        for x in [0...@map.width]
            for y in[0...@map.height]
                point = x: x, y: y
                if _.random(100) > 10
                    @map.empty point
                else
                    @map.fill point

