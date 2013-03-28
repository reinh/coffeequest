(function() {
  var _ref, _ref1,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.MapGenerators = {};

  this.MapGenerators.MapGenerator = (function() {
    function MapGenerator(map) {
      this.map = map;
    }

    return MapGenerator;

  })();

  this.MapGenerators.EmptyMap = (function(_super) {
    __extends(EmptyMap, _super);

    function EmptyMap() {
      _ref = EmptyMap.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    EmptyMap.prototype.generate = function() {
      var x, y, _i, _ref1, _results;

      _results = [];
      for (x = _i = 0, _ref1 = this.map.width; 0 <= _ref1 ? _i < _ref1 : _i > _ref1; x = 0 <= _ref1 ? ++_i : --_i) {
        _results.push((function() {
          var _j, _ref2, _results1;

          _results1 = [];
          for (y = _j = 0, _ref2 = this.map.height; 0 <= _ref2 ? _j < _ref2 : _j > _ref2; y = 0 <= _ref2 ? ++_j : --_j) {
            _results1.push(this.map.empty({
              x: x,
              y: y
            }));
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    return EmptyMap;

  })(this.MapGenerators.MapGenerator);

  this.MapGenerators.RandomMap = (function(_super) {
    __extends(RandomMap, _super);

    function RandomMap() {
      _ref1 = RandomMap.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    RandomMap.prototype.generate = function() {
      var point, x, y, _i, _ref2, _results;

      _results = [];
      for (x = _i = 0, _ref2 = this.map.width; 0 <= _ref2 ? _i < _ref2 : _i > _ref2; x = 0 <= _ref2 ? ++_i : --_i) {
        _results.push((function() {
          var _j, _ref3, _results1;

          _results1 = [];
          for (y = _j = 0, _ref3 = this.map.height; 0 <= _ref3 ? _j < _ref3 : _j > _ref3; y = 0 <= _ref3 ? ++_j : --_j) {
            point = {
              x: x,
              y: y
            };
            if (_.random(100) > 10) {
              _results1.push(this.map.empty(point));
            } else {
              _results1.push(this.map.fill(point));
            }
          }
          return _results1;
        }).call(this));
      }
      return _results;
    };

    return RandomMap;

  })(this.MapGenerators.MapGenerator);

}).call(this);
