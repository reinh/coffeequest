CELL =
    WIDTH: 16
    HEIGHT: 27
    CHAR: (p) -> p.char
    X: (p) -> p.x * CELL.WIDTH
    Y: (p) -> p.y * CELL.HEIGHT
    DX: -> 0
    DY: -> 0.8*CELL.HEIGHT

class @Display
    constructor: (@engine) ->
        @mapDisplay      = new MapDisplay(@engine.world.map)
        @actorDisplay    = new ActorDisplay([@engine.player])
        @messagesDisplay = new MessagesDisplay()
        @distanceDisplay = new CharGridDisplay()

    update: (@engine) ->
        @actorDisplay.update(@engine.actors)
        _.defer =>
            distanceMap = new DijkstraMap @engine.world.map, [@engine.player]
            @distanceDisplay.update distanceMap
        _.defer => @messagesDisplay.update(@engine.messages)

class @MapDisplay
    constructor: (@map) ->
        @update()

    update: ->
        d3.select("svg#map").selectAll("rect.map")
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

class @CharGridDisplay
    constructor: (@grid) -> @update(@grid)

    remove: -> d3.select("svg#map").selectAll("text.char").remove()

    update: (grid) ->
        @grid = grid
        return unless @grid?
        cells = for point in grid.points()
            { x: point.x, y: point.y, char: @grid.get point }

        d3_chars = d3.select("svg#map").selectAll("text.char")
            .data(cells, (g) => @grid.toKey(g))

        fontSize = 10

        d3_chars.enter().append("text")
            .attr("x", CELL.X)
            .attr("y", CELL.Y)
            .attr("dx", CELL.WIDTH/2)
            .attr("dy", CELL.HEIGHT-fontSize)
            .style("fill", "#ddd")
            .style("font-size", fontSize)
            .attr('text-anchor', 'middle')
            .classed("char", true)

        d3_chars
            .text(CELL.CHAR)

        d3_chars.exit().remove()

class @ActorDisplay
    constructor: (@actors) ->

    update: (actors) ->
        hp = (a) -> d3.interpolateLab("#F44", "#444")(a.hp/a.maxHp)
        d3_actors = d3.select("svg#map").selectAll("text.actor").data(actors)

        d3_actors.enter()
            .append("text")
            .text(CELL.CHAR)
            .attr("x", CELL.X)
            .attr("y", CELL.Y)
            .attr("dx", CELL.DX)
            .attr("dy", CELL.DY)
            .classed("actor", true)

        d3_actors.transition()
            .duration(150)
            .style('fill', hp)
            .attr("x", CELL.X)
            .attr("y", CELL.Y)

        d3_actors.exit().transition()
            .duration(100)
            .style('fill-opacity', 0)
            .attr("y", (a) -> CELL.Y(a) + 6)
            .remove()

class @MessagesDisplay
    update: (messages) ->
        last_messages = _.last messages, 5

        duration = 100
        top      = 15
        height   = 20

        idx = (m) -> last_messages.indexOf m
        y   = (m) -> top + idx(m) * height
        weight = (m) -> if m.important? then 'bold' else 'regular'

        d3_messages = d3.select("svg#messages").selectAll("text")
            .data(last_messages, (m) -> m.id )

        d3_messages.enter()
            .append("text")
            .attr("x", 0)
            .attr("y", (m) -> y(m) + height)
            .text( (m) -> m.text )
            .style('font-weight', weight)
            .style('fill-opacity', 0)
            .transition()
                .duration(10)
                .attr("y", y)

        d3_messages.transition()
            .duration(duration)
            .style('fill-opacity', 1)
            .attr("y", y)

        d3_messages.exit().transition()
            .duration(duration)
            .style('fill-opacity', 0)
            .attr("y", top - height)
            .remove()
