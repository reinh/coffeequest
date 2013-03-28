(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __slice = [].slice;

  this.Scheduler = (function() {
    function Scheduler(items) {
      this.items = items;
      this.index = 0;
    }

    Scheduler.prototype.next = function() {
      var item;

      item = this.items[this.index];
      this.index++;
      if (this.index >= this.items.length) {
        this.index = 0;
      }
      return item;
    };

    return Scheduler;

  })();

  this.Engine = (function() {
    function Engine(world, context) {
      var height, width, _ref,
        _this = this;

      this.world = world;
      this.context = context;
      this.move = __bind(this.move, this);
      this.run = __bind(this.run, this);
      _ref = this.world.dimensions, height = _ref.height, width = _ref.width;
      this.player = new Player(0, 0);
      this.actors = [this.player, new Actor(5, 5)];
      this.scheduler = new Scheduler(this.actors);
      this.messages = [];
      Backbone.on('move', function() {
        var args;

        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return _this.move.apply(_this, args);
      });
      Backbone.on('message', function(message, important) {
        var _ref1;

        if (typeof message === "string") {
          message = {
            text: message
          };
        }
        message.id = _.uniqueId('message');
        if ((_ref1 = message.important) == null) {
          message.important = important;
        }
        _this.messages.push(message);
        return _this.messages = _.last(_this.messages, 100);
      });
      this.display = new Display(this);
    }

    Engine.prototype.run = function() {
      this.display.update(this);
      return new Turn(this, this.scheduler.next()).run();
    };

    Engine.prototype.move = function(actor, dx, dy) {
      var message, newPoint, target, what, who, whom;

      newPoint = {
        x: actor.x + dx,
        y: actor.y + dy
      };
      target = _.find(this.actors, function(actor) {
        return actor.at(newPoint);
      });
      switch (false) {
        case !target:
          who = actor === this.player ? 'You' : actor.char;
          what = "attack" + (actor === this.player ? '' : 's');
          whom = target.name;
          message = {
            text: ""
          };
          actor.attack(target);
          if (target.isAlive()) {
            message.text += "" + who + " " + what + " " + whom + ".";
            if (target.isHurt()) {
              message.text += " It is badly injured!";
            }
          } else {
            this.actors = _.difference(this.actors, [target]);
            message.text += "" + who + " kill " + whom + "!";
            message.important = true;
          }
          return Backbone.trigger('message', message);
        case !this.world.isBlocked(newPoint):
          if (actor === this.player) {
            return Backbone.trigger('message', 'You are blocked!');
          }
          break;
        default:
          return _.extend(actor, newPoint);
      }
    };

    return Engine;

  })();

}).call(this);
