$ ->
    world = new World height: 30, width: 80
    window.engine = new Engine world, $(window)
    engine.run()
