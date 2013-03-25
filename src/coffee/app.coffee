$ ->
    world = new World height: 20, width: 50
    window.engine = new Engine world, $(window)
    engine.run()
