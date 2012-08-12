class Wasteland
  constructor: ->
    @land = $('#wasteland')
    @addGameArea()
    # addTiles()

  addGameArea: ->
    builder = new Builder()
    builder.div('board', {'background': 'red', height: '280px'})
    @land.append(builder.main)

class Builder
  constructor: ->
    @main = $('<div></div>')
    @current = @main

  html: ->
    @main.html()

  div: (id, options) ->
    @current = $("<div id='" + id + "'></div>")
    if options
      for k in @keys(options)
        @current.css(this, options[this])
    @main.append(@current)

  keys: (hash) ->
    keys = []
    for k in hash
      keys.push(k);
    keys


$ ->
  if $('#wasteland')
    new Wasteland()