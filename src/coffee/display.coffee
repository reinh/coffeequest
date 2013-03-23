class Display
    defaults:
        rows: 20
        columns: 80
        font: '"Source Code Pro", "Andale Mono", monospace'
        fontsize: '24px'
        background: '#000'
        foreground: '#CCC'
        padding: '5px'

    constructor: (@options={}) ->
        @options = _.defaults @options, @defaults
        @dirty = true
        @content = (Array(@options.columns) for row in [1..@options.rows])
        @el = @makeElement()
        @el.appendTo 'body'
        @_setupEvents()

    _setupEvents: ->
        Backbone.on 'render', => @render()
        Backbone.on 'set', (x, y, char) => @set(x, y, char)

    render: ->
        return unless @dirty?
        @el.val @toString()
        @dirty = false
        return true

    toString: -> ((cell or " " for cell in row).join("") for row in @content).join("\n")

    set: (x,y, val) ->
        @content[y][x] = val

    makeElement: ->
        el = $('<textarea></textarea>')

        el.attr
            rows: @options.rows
            cols: @options.columns
            disabled: true

        el.css
            'font-family' : @options.font
            'font-size'   : @options.fontsize
            color         : @options.foreground
            background    : @options.background
            padding       : @options.padding
            border        : 0

        return el


@Display = Display
