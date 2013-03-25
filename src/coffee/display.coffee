CELL =
    WIDTH: 16
    HEIGHT: 27
    CHAR: (p) -> p.char
    X: (p) -> p.x * CELL.WIDTH
    Y: (p) -> p.y * CELL.HEIGHT
    DY: -> 0.8*CELL.HEIGHT

class @Display
    constructor: (@engine) ->
        @mapDisplay = new MapDisplay(@engine.world.map)
        @actorDisplay = new ActorDisplay(@engine.actors)

    update: ->
        @actorDisplay.update()

class @MapDisplay
    constructor: (@map) ->
        @update()

    update: ->
        d3.select("body svg").selectAll("rect.map")
            .data(@map.points())
            .enter()
                .append("rect")
                .attr("width",  CELL.WIDTH)
                .attr("height", CELL.HEIGHT)
                .attr("x", CELL.X)
                .attr("y", CELL.Y)
                .classed("map", true)
                .classed("wall",  (p) => @map.isWall?(p) )
                .classed("floor", (p) => not @map.isWall?(p) )

class @ActorDisplay
    constructor: (@actors) ->

    update: ->
        d3_actors = d3.select("body svg").selectAll("text.actor").data(@actors)

        d3_actors.enter()
            .append("text")
            .text(CELL.CHAR)
            .attr("x", CELL.X)
            .attr("y", CELL.Y)
            .attr("dy", CELL.DY)
            .classed("actor", true)

        d3_actors.transition()
            .duration(150)
            .attr("x", CELL.X)
            .attr("y", CELL.Y)
