(function() {
  var _ref, _ref1,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  this.Actor = (function() {
    function Actor(x, y) {
      this.x = x;
      this.y = y;
      this.hp = this.maxHp = 10;
    }

    Actor.prototype.name = 'the orc';

    Actor.prototype.char = 'o';

    Actor.prototype.damage = 3;

    Actor.prototype.dead = false;

    Actor.prototype.at = function(p) {
      if (this.dead) {
        return false;
      }
      return p.x === this.x && p.y === this.y;
    };

    Actor.prototype.attack = function(actor) {
      return actor.hit(this.damage);
    };

    Actor.prototype.hit = function(damage) {
      return this.dead = (this.hp -= damage) <= 0;
    };

    Actor.prototype.isAlive = function() {
      return !this.dead;
    };

    Actor.prototype.isHurt = function() {
      return this.hp / this.maxHp < 1 / 3;
    };

    Actor.prototype.act = function(turn) {
      return turn.end();
    };

    return Actor;

  })();

  this.Random = (function(_super) {
    __extends(Random, _super);

    function Random() {
      _ref = Random.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Random.prototype.char = '%';

    Random.prototype.act = function(turn) {
      var dir;

      dir = [_.random(-1, 1), _.random(-1, 1)];
      Backbone.trigger.apply(Backbone, ['move', this].concat(__slice.call(dir)));
      return turn.end();
    };

    return Random;

  })(Actor);

  this.Player = (function(_super) {
    __extends(Player, _super);

    function Player() {
      _ref1 = Player.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    Player.prototype.char = '@';

    Player.prototype.name = 'the Hero';

    Player.prototype.act = function(turn) {
      var _this = this;

      return turn.context.one('keyup', function(e) {
        var dir;

        dir = (function() {
          switch (e.which) {
            case Keys.Y:
              return [-1, -1];
            case Keys.U:
              return [1, -1];
            case Keys.H:
              return [-1, 0];
            case Keys.J:
              return [0, 1];
            case Keys.K:
              return [0, -1];
            case Keys.L:
              return [1, 0];
            case Keys.B:
              return [-1, 1];
            case Keys.N:
              return [1, 1];
            default:
              return null;
          }
        })();
        if (dir != null) {
          Backbone.trigger.apply(Backbone, ['move', _this].concat(__slice.call(dir)));
          return turn.end();
        } else {
          return turn.redo();
        }
      });
    };

    return Player;

  })(Actor);

}).call(this);
