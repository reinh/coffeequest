(function() {
  var CELL;

  CELL = {
    WIDTH: 16,
    HEIGHT: 27,
    CHAR: function(p) {
      return p.char;
    },
    X: function(p) {
      return p.x * CELL.WIDTH;
    },
    Y: function(p) {
      return p.y * CELL.HEIGHT;
    },
    DX: function() {
      return 0;
    },
    DY: function() {
      return 0.8 * CELL.HEIGHT;
    }
  };

  this.Display = (function() {
    function Display(engine) {
      this.engine = engine;
      this.mapDisplay = new MapDisplay(this.engine.world.map);
      this.actorDisplay = new ActorDisplay([this.engine.player]);
      this.messagesDisplay = new MessagesDisplay();
      this.distanceDisplay = new CharGridDisplay();
    }

    Display.prototype.update = function(engine) {
      var _this = this;

      this.engine = engine;
      this.actorDisplay.update(this.engine.actors);
      _.defer(function() {
        var distanceMap;

        distanceMap = new DijkstraMap(_this.engine.world.map, [_this.engine.player]);
        return _this.distanceDisplay.update(distanceMap);
      });
      return _.defer(function() {
        return _this.messagesDisplay.update(_this.engine.messages);
      });
    };

    return Display;

  })();

  this.MapDisplay = (function() {
    function MapDisplay(map) {
      this.map = map;
      this.update();
    }

    MapDisplay.prototype.update = function() {
      var _this = this;

      return d3.select("svg#map").selectAll("rect.map").data(this.map.points()).enter().append("rect").attr("width", CELL.WIDTH).attr("height", CELL.HEIGHT).attr("x", CELL.X).attr("y", CELL.Y).classed("map", true).classed("wall", function(p) {
        var _base;

        return typeof (_base = _this.map).isWall === "function" ? _base.isWall(p) : void 0;
      }).classed("floor", function(p) {
        var _base;

        return !(typeof (_base = _this.map).isWall === "function" ? _base.isWall(p) : void 0);
      });
    };

    return MapDisplay;

  })();

  this.CharGridDisplay = (function() {
    function CharGridDisplay(grid) {
      this.grid = grid;
      this.update(this.grid);
    }

    CharGridDisplay.prototype.remove = function() {
      return d3.select("svg#map").selectAll("text.char").remove();
    };

    CharGridDisplay.prototype.update = function(grid) {
      var cells, d3_chars, fontSize, point,
        _this = this;

      this.grid = grid;
      if (this.grid == null) {
        return;
      }
      cells = (function() {
        var _i, _len, _ref, _results;

        _ref = grid.points();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          point = _ref[_i];
          _results.push({
            x: point.x,
            y: point.y,
            char: this.grid.get(point)
          });
        }
        return _results;
      }).call(this);
      d3_chars = d3.select("svg#map").selectAll("text.char").data(cells, function(g) {
        return _this.grid.toKey(g);
      });
      fontSize = 10;
      d3_chars.enter().append("text").attr("x", CELL.X).attr("y", CELL.Y).attr("dx", CELL.WIDTH / 2).attr("dy", CELL.HEIGHT - fontSize).style("fill", "#ddd").style("font-size", fontSize).attr('text-anchor', 'middle').classed("char", true);
      d3_chars.text(CELL.CHAR);
      return d3_chars.exit().remove();
    };

    return CharGridDisplay;

  })();

  this.ActorDisplay = (function() {
    function ActorDisplay(actors) {
      this.actors = actors;
    }

    ActorDisplay.prototype.update = function(actors) {
      var d3_actors, hp;

      hp = function(a) {
        return d3.interpolateLab("#F44", "#444")(a.hp / a.maxHp);
      };
      d3_actors = d3.select("svg#map").selectAll("text.actor").data(actors);
      d3_actors.enter().append("text").text(CELL.CHAR).attr("x", CELL.X).attr("y", CELL.Y).attr("dx", CELL.DX).attr("dy", CELL.DY).classed("actor", true);
      d3_actors.transition().duration(150).style('fill', hp).attr("x", CELL.X).attr("y", CELL.Y);
      return d3_actors.exit().transition().duration(100).style('fill-opacity', 0).attr("y", function(a) {
        return CELL.Y(a) + 6;
      }).remove();
    };

    return ActorDisplay;

  })();

  this.MessagesDisplay = (function() {
    function MessagesDisplay() {}

    MessagesDisplay.prototype.update = function(messages) {
      var d3_messages, duration, height, idx, last_messages, top, weight, y;

      last_messages = _.last(messages, 5);
      duration = 100;
      top = 15;
      height = 20;
      idx = function(m) {
        return last_messages.indexOf(m);
      };
      y = function(m) {
        return top + idx(m) * height;
      };
      weight = function(m) {
        if (m.important != null) {
          return 'bold';
        } else {
          return 'regular';
        }
      };
      d3_messages = d3.select("svg#messages").selectAll("text").data(last_messages, function(m) {
        return m.id;
      });
      d3_messages.enter().append("text").attr("x", 0).attr("y", function(m) {
        return y(m) + height;
      }).text(function(m) {
        return m.text;
      }).style('font-weight', weight).style('fill-opacity', 0).transition().duration(10).attr("y", y);
      d3_messages.transition().duration(duration).style('fill-opacity', 1).attr("y", y);
      return d3_messages.exit().transition().duration(duration).style('fill-opacity', 0).attr("y", top - height).remove();
    };

    return MessagesDisplay;

  })();

}).call(this);
