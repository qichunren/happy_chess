class PiecePoint

  constructor: (x, y) ->
    @x = x
    @y = y
    @is_hover = false
    @state = null # null means blank, it may be point to a red/blank piece.

  x_in_world: ->
    @x * Game.piece_padding + Game.margin_left

  y_in_world: ->
    ((Game.rows-1) - @y) * Game.piece_padding + Game.margin_top

  is_same: (other) ->
    @x == other.x && @y == other.y

  hover: ->
    @is_hover = true

  hout: ->
    @is_hover = false

  renderTo:(ctx) ->
    if @is_hover
      ctx.beginPath()
      ctx.arc(@x_in_world(), @y_in_world(), 4, 0, 2 * Math.PI, false)
      ctx.lineWidth = 5
      ctx.strokeStyle = '#003300'
      ctx.stroke()

  is_at_top_edge: ->
    @y == 9

  is_at_bottom: ->
    @y == 0

  is_at_left_edge: ->
    @x == 0

  is_at_right_edge: ->
    @x == (Game.columns - 1)

  is_at_self_river: ->
    @y == 4

  is_at_enmy_river: ->
    @y == 5

  toPosition: ->
    {x : @x * Game.piece_padding, y : ((Game.rows-1) - @y) * Game.piece_padding  }

  toPositionInWorld: ->
    {x : @x * Game.piece_padding + Game.margin_left, y : ((Game.rows-1) - @y) * Game.piece_padding + Game.margin_top }