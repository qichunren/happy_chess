class PiecePoint

  @clone:(point) ->
    new PiecePoint(point.x, point.y)

  constructor: (x, y) ->
    @x = x
    @y = y
    @is_hover = false
    @moveable = false
    @is_selected = false
    @state = null # null means blank, it may be point to a red/black piece.
    @marker_size1 = 12
    @marker_size2 = 8
    @marker_size3 = 6

  x_in_world: ->
    @x * Game.piece_padding + Game.margin_left

  y_in_world: ->
    ((Game.rows-1) - @y) * Game.piece_padding + Game.margin_top

  is_at: (x, y) ->
    @x == x && @y == y

  is_same: (other) ->
    @x == other.x && @y == other.y

  hover: ->
    @is_hover = true

  hout: ->
    @is_hover = false

  mark_moveable: ->
    @moveable = true

  reset_moveable: ->
    @moveable = false

  renderTo:(ctx) ->
    if @is_hover
#      ctx.beginPath()
#      ctx.arc(@x_in_world(), @y_in_world(), 4, 0, 2 * Math.PI, false)
#      ctx.lineWidth = 5
#      ctx.strokeStyle = '#003300'
#      ctx.stroke()
      ctx.beginPath()
      ctx.rect(@x_in_world()-@marker_size3/2, @y_in_world()-@marker_size3/2, @marker_size3, @marker_size3)
      ctx.lineWidth = 1
      ctx.strokeStyle = '#FF9900'
      ctx.stroke()
    if @moveable
      ctx.beginPath()
      ctx.rect(@x_in_world()-@marker_size2/2, @y_in_world()-@marker_size2/2, @marker_size2, @marker_size2)
      ctx.lineWidth = 1
      ctx.strokeStyle = 'green'
      ctx.stroke()
    if @is_selected
      ctx.beginPath()
      ctx.rect(@x_in_world()-@marker_size1/2, @y_in_world()-@marker_size1/2, @marker_size1, @marker_size1)
      ctx.lineWidth = 1
      ctx.strokeStyle = 'blue'
      ctx.stroke()


  is_in: (points) ->
    is_include = false
    for point in points
      if @is_same(point)
        is_include = true
        return is_include
    is_include

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