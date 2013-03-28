(function() {
  var World;

  World = (function() {
    function World(dimensions) {
      this.dimensions = dimensions;
      this.map = new Map(this.dimensions);
    }

    World.prototype.paint = function(display) {
      var col, point, row, _i, _ref, _results;

      _results = [];
      for (row = _i = 0, _ref = this.dimensions.height; 0 <= _ref ? _i < _ref : _i > _ref; row = 0 <= _ref ? ++_i : --_i) {
        _results.push((function() {
          var _j, _ref1, _results1;

          _results1 = [];
          for (col = _j = 0, _ref1 = this.dimensions.width; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; col = 0 <= _ref1 ? ++_j : --_j) {
            point = {
              x: col,
              y: row
            };
            _results1.push(display.set(point, this.charAt(point)));
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    World.prototype.charAt = function(point) {
      return this.map.charAt(point);
    };

    World.prototype.isBlocked = function(x, y) {
      return this.map.isBlocked(x, y);
    };

    return World;

  })();

  this.World = World;

}).call(this);
