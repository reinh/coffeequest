(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  this.Map = (function(_super) {
    __extends(Map, _super);

    Map.prototype.FLOOR = '.';

    Map.prototype.WALL = '#';

    function Map(dim) {
      this.isFloor = __bind(this.isFloor, this);
      this.isWall = __bind(this.isWall, this);      Map.__super__.constructor.apply(this, arguments);
      this.id = _.uniqueId('map');
      this.height = dim.height;
      this.width = dim.width;
      new MapGenerators.RandomMap(this).generate();
    }

    Map.prototype.empty = function(p) {
      return this.set(p, false);
    };

    Map.prototype.fill = function(p) {
      return this.set(p, true);
    };

    Map.prototype.isWall = function(p) {
      return this.get(p) === true;
    };

    Map.prototype.isFloor = function(p) {
      return this.get(p) === false;
    };

    Map.prototype.isBlocked = function(p) {
      return this.outOfBounds(p) || this.isWall(p);
    };

    Map.prototype.charAt = function(p) {
      if (this.isWall(p)) {
        return this.WALL;
      } else {
        return this.FLOOR;
      }
    };

    return Map;

  })(this.Grid);

}).call(this);
