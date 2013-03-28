(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.DijkstraMap = (function(_super) {
    __extends(DijkstraMap, _super);

    DijkstraMap.cache = LRUCache(50);

    function DijkstraMap(map, goals) {
      var goal, point, _i, _j, _len, _len1, _ref, _ref1;

      this.map = map;
      this.goals = goals;
      DijkstraMap.__super__.constructor.apply(this, arguments);
      this.updates = 0;
      _ref = this.map.points();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        point = _ref[_i];
        if (this.map.isFloor(point)) {
          this.set(point, Infinity);
        }
      }
      _ref1 = this.goals;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        goal = _ref1[_j];
        this.set(goal, 0);
      }
      this.calculate();
    }

    DijkstraMap.prototype.hash = function() {
      var goalStr;

      goalStr = (_.map(this.goals, function(g) {
        return "[" + g.x + "," + g.y + "]";
      })).join(",");
      return "" + this.map.id + "-" + goalStr;
    };

    DijkstraMap.prototype.charAt = function(p) {
      return "" + (this.get(p));
    };

    DijkstraMap.prototype.calculate = function() {
      var key;

      key = this.hash();
      if (DijkstraMap.cache.has(key)) {
        _.debug("cache hit:  " + key);
        return this.cells = DijkstraMap.cache.get(key);
      } else {
        _.debug("cache miss: " + key);
        this.update();
        return DijkstraMap.cache.set(key, this.cells);
      }
    };

    DijkstraMap.prototype.update = function() {
      var old, point, _i, _len, _ref;

      this.updates++;
      old = _.extend({}, this.cells);
      _ref = this.points();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        point = _ref[_i];
        this.updateCell(point);
      }
      if (!(_.isEqual(old, this.cells) || this.updates > 1000)) {
        return this.update();
      }
    };

    DijkstraMap.prototype.updateCell = function(point) {
      var lowest_neighbor_value, neighbors, value,
        _this = this;

      value = this.get(point);
      if (value !== Infinity) {
        return;
      }
      neighbors = this.neighbors(point);
      lowest_neighbor_value = _.min(_.map(neighbors, function(n) {
        return _this.get(n);
      }));
      if (value - 2 > lowest_neighbor_value) {
        return this.set(point, lowest_neighbor_value + 1);
      }
    };

    DijkstraMap.prototype.neighbors = function(cell) {
      var a, p, possibles,
        _this = this;

      possibles = (function() {
        var _i, _len, _ref, _results;

        _ref = _.product([-1, 0, 1], [-1, 0, 1]);
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          a = _ref[_i];
          p = _.toPoint(a);
          _results.push({
            x: p.x + cell.x,
            y: p.y + cell.y
          });
        }
        return _results;
      })();
      return _.reject(possibles, function(point) {
        var originalCell;

        originalCell = point.x === cell.x && point.y === cell.y;
        return originalCell || _this.outOfBounds(point);
      });
    };

    return DijkstraMap;

  })(this.Grid);

}).call(this);
