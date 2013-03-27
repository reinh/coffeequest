@_.mixin
    toPoint: (arr) -> {x: arr[0], y: arr[1]}

    product: ->
      _.reduce arguments, ((a, b) ->
        _.flatten _.map(a, (x) ->
          _.map b, (y) ->
            x.concat [y]

        ), true
      ), [[]]

    debug: -> console.log arguments if _.DEBUG
