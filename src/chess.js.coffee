requestAnimFrame = (->
  window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) ->
    window.setTimeout callback, 1000 / 60
    return
)()

class PiecePoint

  constructor: (x, y) ->
    @x = x
    @y = y
    @is_hover = false

  x_in_world: ->
    @x * ChineseChess.piece_padding + ChineseChess.margin_left

  y_in_world: ->
    ((ChineseChess.rows-1) - @y) * ChineseChess.piece_padding + ChineseChess.margin_top

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
    @x == (ChineseChess.columns - 1)

  is_at_self_river: ->
    @y == 4

  is_at_enmy_river: ->
    @y == 5

  toPosition: ->
    {x : @x * ChineseChess.piece_padding, y : ((ChineseChess.rows-1) - @y) * ChineseChess.piece_padding  }

  toPositionInWorld: ->
    {x : @x * ChineseChess.piece_padding + ChineseChess.margin_left, y : ((ChineseChess.rows-1) - @y) * ChineseChess.piece_padding + ChineseChess.margin_top }

class Chess

  main: =>
    now = Date.now()
    dt = (now - @lastTime) / 1000.0
    @update dt
    @render()
    @lastTime = now
    requestAnimFrame @main
    return

  update: (dt) ->
    @current_points = []
    for piece in @pieces
      @current_points.push(piece.point)
      if @selected_piece == piece
        console.log('selected piece: ', piece.point.x, piece.point.y)
        if @target_point
          @selected_piece.move_to_point(@target_point)
          @selected_piece.update(dt)



  render: ->
    @ctx.fillStyle = '#FFF';
    @ctx.fillRect(0, 0, @ctx_width, @ctx_height)
    @drawMap()

    for point in @all_points
      point.renderTo(@ctx)

    for piece in @pieces
      piece.renderTo(@ctx)


  constructor: (canvas_id = 'chess_game') ->
    @debug = true
    @lastTime = Date.now()
    @canvas_element = document.getElementById(canvas_id)
    @canvasElemLeft = @canvas_element.offsetLeft
    @canvasElemTop = @canvas_element.offsetTop
    @ctx = @canvas_element.getContext('2d')
    @ctx_width = 800
    @ctx_height = 600
    @margin_top = ChineseChess.margin_top
    @margin_left = ChineseChess.margin_left

    @piece_margin = ChineseChess.piece_padding

    @columns = ChineseChess.columns
    @rows = ChineseChess.rows

    @panel_width = (@columns - 1) * @piece_margin
    @panel_height = (@rows - 1) * @piece_margin

    @all_points = []
    @current_points = []
    @selected_piece = null
    @target_point
    console.log("panel width, height: ", @panel_width, @panel_height) if @debug


  is_blank_point: (point) ->
    found = false
    for _point in @current_points
      found = true if point.is_same(_point)
      break

    return found == false

  point:(x, y) ->
    point = null
    for _point in @all_points
        if _point.x == x && _point.y == y
          point = _point
          break
    point

  fill_points: ->
    column_array = [0..(@columns-1)]
    row_array = [0..(@rows-1)]
    for y in row_array
      for x in column_array
        @all_points.push(new PiecePoint(x, y))

  init: ->
    @fill_points()
    @setupPieces()
    @setupEventListener()
    @main()

  drawMap: ->
    # First draw 4 edge borders
    lb_point = @point(0,0)
    rb_point = @point(8,0)
    lt_point = @point(0,9)
    rt_point = @point(8,9)
    @ctx.beginPath()
    @ctx.strokeStyle = '#000000'
    @ctx.lineWidth = 4
    @ctx.moveTo(lb_point.x_in_world(), lb_point.y_in_world())
    @ctx.lineTo(lt_point.x_in_world(), lt_point.y_in_world())
    @ctx.stroke()

    @ctx.beginPath()
    @ctx.moveTo(lt_point.x_in_world(), lt_point.y_in_world())
    @ctx.lineTo(rt_point.x_in_world(), rt_point.y_in_world())
    @ctx.stroke()

    @ctx.beginPath()
    @ctx.moveTo(rt_point.x_in_world(), rt_point.y_in_world())
    @ctx.lineTo(rb_point.x_in_world(), rb_point.y_in_world())
    @ctx.stroke()

    @ctx.beginPath()
    @ctx.moveTo(rb_point.x_in_world(), rb_point.y_in_world())
    @ctx.lineTo(lb_point.x_in_world(), lb_point.y_in_world())
    @ctx.stroke()

    # 2: Draw rows
    @ctx.strokeStyle = '#BDBDBD'
    @ctx.lineWidth = 1
    for _y in [1..8]
      left_edge_point = @point(0, _y)
      right_edge_point = @point(8, _y)
      @ctx.beginPath()
      @ctx.moveTo(left_edge_point.x_in_world(), left_edge_point.y_in_world())
      @ctx.lineTo(right_edge_point.x_in_world(), right_edge_point.y_in_world())
      @ctx.stroke()

    # 3: Draw self columns
    for _x in [1..7]
      b_point = @point(_x, 0)
      t_point = @point(_x, 4)
      @ctx.beginPath()
      @ctx.moveTo(b_point.x_in_world(), b_point.y_in_world())
      @ctx.lineTo(t_point.x_in_world(), t_point.y_in_world())
      @ctx.stroke()
    # 4: Draw enmy columns
    for _x2 in [1..7]
      b2_point = @point(_x2, 5)
      t2_point = @point(_x2, 9)
      @ctx.beginPath()
      @ctx.moveTo(b2_point.x_in_world(), b2_point.y_in_world())
      @ctx.lineTo(t2_point.x_in_world(), t2_point.y_in_world())
      @ctx.stroke()

    # 5: Draw self house line
    s1_point = @point(3,0)
    s11_point = @point(5,2)
    @ctx.beginPath()
    @ctx.moveTo(s1_point.x_in_world(), s1_point.y_in_world())
    @ctx.lineTo(s11_point.x_in_world(), s11_point.y_in_world())
    @ctx.stroke()
    s2_point = @point(5,0)
    s22_point = @point(3,2)
    @ctx.beginPath()
    @ctx.moveTo(s2_point.x_in_world(), s2_point.y_in_world())
    @ctx.lineTo(s22_point.x_in_world(), s22_point.y_in_world())
    @ctx.stroke()
    # 6: Draw enmy house line
    s3_point = @point(3,7)
    s33_point = @point(5,9)
    @ctx.beginPath()
    @ctx.moveTo(s3_point.x_in_world(), s3_point.y_in_world())
    @ctx.lineTo(s33_point.x_in_world(), s33_point.y_in_world())
    @ctx.stroke()
    s4_point = @point(5,7)
    s44_point = @point(3,9)
    @ctx.beginPath()
    @ctx.moveTo(s4_point.x_in_world(), s4_point.y_in_world())
    @ctx.lineTo(s44_point.x_in_world(), s44_point.y_in_world())
    @ctx.stroke()

  setupPieces: ->
    @pieces = []
    for name in ['car_l', 'car_r', 'horse_l', 'horse_r', 'elephant_l', 'elephant_r', 'knight_l', 'knight_r', 'chief', 'gun_l', 'gun_r', 'soldier_1', 'soldier_2', 'soldier_3', 'soldier_4', 'soldier_5']
      piece = new Piece(name, 'red')
      @pieces.push(piece)
      @current_points.push(piece.point)

  setupEventListener: ->
    @canvas_element.addEventListener 'mousemove', (event) =>
      x = event.pageX - @canvasElemLeft
      y = event.pageY - @canvasElemTop
      for piece in @pieces
        if x >= piece.point.x_in_world() - ChineseChess.radius && x <= piece.point.x_in_world() + ChineseChess.radius && y >= piece.point.y_in_world() - ChineseChess.radius && y <= piece.point.y_in_world() + ChineseChess.radius
          piece.hover()
        else
          piece.hout()

      for every_point in @all_points
        if x >= every_point.x_in_world() - ChineseChess.radius && x <= every_point.x_in_world() + ChineseChess.radius && y >= every_point.y_in_world() - ChineseChess.radius && y <= every_point.y_in_world() + ChineseChess.radius
          if @is_blank_point(every_point)
            every_point.hover()
        else
          every_point.hout()

    @canvas_element.addEventListener 'click', (event) =>
      x = event.pageX - @canvasElemLeft
      y = event.pageY - @canvasElemTop
      console.log('receive click event on canvas: ', x, y)
      for piece in @pieces
        if x >= piece.point.x_in_world() - ChineseChess.radius && x <= piece.point.x_in_world() + ChineseChess.radius && y >= piece.point.y_in_world() - ChineseChess.radius && y <= piece.point.y_in_world() + ChineseChess.radius
          piece.active()
          @selected_piece = piece
        else
          piece.deactive()

      for every_point in @all_points
        if x >= every_point.x_in_world() - ChineseChess.radius && x <= every_point.x_in_world() + ChineseChess.radius && y >= every_point.y_in_world() - ChineseChess.radius && y <= every_point.y_in_world() + ChineseChess.radius
          if @is_blank_point(every_point)
            @target_point = every_point
            break



$ ->
  chess_game = new Chess()
  window.t = chess_game

  chess_game.init()
