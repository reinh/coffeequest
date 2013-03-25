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
        @actorDisplay    = new ActorDisplay(@engine.actors)
        @messagesDisplay = new MessagesDisplay()

    update: (@engine) ->
        @actorDisplay.update(@engine.actors)
        @messagesDisplay.update(@engine.messages)

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
        duration = 100
        y = (m) -> 15 + last_messages.indexOf(m) * 20
        last_messages = _.last messages, 5
        d3_messages = d3.select("svg#messages").selectAll("text")
            .data(last_messages, (m) -> m.id )

        d3_messages.enter()
            .append("text")
            .attr("x", 0)
            .attr("y", (m) -> y(m) + 20)
            .text( (m) -> m.text )
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
            .attr("y", -5)
            .remove()
