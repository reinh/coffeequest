(function() {
  var __hasProp = {}.hasOwnProperty;

  this.Grid = (function() {
    function Grid() {
      this.cells = {};
    }

    Grid.prototype.toKey = function(p) {
      return "" + p.x + "," + p.y;
    };

    Grid.prototype.get = function(p) {
      return this.cells[this.toKey(p)];
    };

    Grid.prototype.set = function(p, val) {
      return this.cells[this.toKey(p)] = val;
    };

    Grid.prototype.outOfBounds = function(p) {
      return !(this.toKey(p) in this.cells);
    };

    Grid.prototype.points = function() {
      var key, _, _ref, _results;

      _ref = this.cells;
      _results = [];
      for (key in _ref) {
        if (!__hasProp.call(_ref, key)) continue;
        _ = _ref[key];
        _results.push(this.toPoint(key));
      }
      return _results;
    };

    Grid.prototype.toPoint = function(key) {
      var x, y, _ref;

      _ref = key.split(","), x = _ref[0], y = _ref[1];
      return {
        x: parseInt(x),
        y: parseInt(y)
      };
    };

    return Grid;

  })();

}).call(this);
