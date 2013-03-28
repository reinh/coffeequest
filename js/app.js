(function() {
  $(function() {
    var world;

    world = new World({
      height: 20,
      width: 50
    });
    window.engine = new Engine(world, $(window));
    return engine.run();
  });

}).call(this);
