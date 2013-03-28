(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.Turn = (function() {
    function Turn(engine, actor) {
      this.engine = engine;
      this.actor = actor;
      this.finish = __bind(this.finish, this);
      this.retry = __bind(this.retry, this);
      this.run = __bind(this.run, this);
      this.context = $(window);
      this.promise = $.Deferred();
      this.promise.fail(this.retry);
      this.promise.done(this.finish);
    }

    Turn.prototype.end = function() {
      return this.promise.resolve();
    };

    Turn.prototype.redo = function() {
      return this.promise.reject();
    };

    Turn.prototype.run = function() {
      return this.actor.act(this);
    };

    Turn.prototype.retry = function() {
      return new Turn(this.engine, this.actor).run();
    };

    Turn.prototype.finish = function() {
      return this.engine.run();
    };

    return Turn;

  })();

}).call(this);
