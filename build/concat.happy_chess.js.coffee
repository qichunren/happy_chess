requestAnimFrame = (->
  window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback) ->
    window.setTimeout callback, 1000 / 60
    return
)()

window.Game = {}

Game.columns = 9
Game.rows = 10
Game.margin_top  = 50
Game.margin_left = 50
Game.piece_padding = 60
Game.radius = 26
Game.is_debug = true
Game.log = (message) ->
  console.log('Chess: ', message) if Game.is_debug

#### Another file ####

class Piece
  @reverse_point: (p) ->
    { x: ( 8 - p.x ), y: ( 9 - p.y ) }

  constructor: (name_symbol, color) ->
    @name_symbol = name_symbol
    @name = if @name_symbol.indexOf('_') > -1 then @name_symbol.split('_')[0] else @name_symbol

    @is_alive = true
    @is_selected = false
    @is_hover = false
    @color = color
    @point = new PiecePoint(@start_point().x, @start_point().y)
    @target_point = null

  set_point: (point) ->
    @point = point

  move_to_point: (target_point) ->
    @target_point = PiecePoint.clone(target_point)
    target_point = null
    return

  update: (dt) ->
    if @target_point
      if @target_point.x != @point.x
        @point.x -= 1 if @target_point.x < @point.x
        @point.x += 1 if @target_point.x > @point.x
      if @target_point.y != @point.y
        @point.y -= 1 if @target_point.y < @point.y
        @point.y += 1 if @target_point.y > @point.y
#      if @target_point.x == @point.x && @target_point.y == @point.y
#        @set_point(@target_point)
    return

  renderTo: (ctx) ->
    ctx.beginPath()
    ctx.arc(@point.x_in_world(), @point.y_in_world(), Game.radius, 0, 2 * Math.PI, false)
    ctx.fillStyle = @color
    ctx.fill()
    ctx.lineWidth = 5
    if @is_selected
      ctx.strokeStyle = '#FF9900'
    else
      if @is_hover
        ctx.strokeStyle = '#BDBDBD'
      else
        ctx.strokeStyle = '#003300'

    ctx.stroke()
    ctx.font = '20pt Calibri'
    ctx.fillStyle = '#FFF'
    ctx.textAlign = 'center'
    ctx.fillText(@label(), @point.x_in_world(), @point.y_in_world() + 10)
    return

  label: ->
    l = null
    if @name == 'carriage'
      l = if @color == 'red' then '车' else '車'
    if @name == 'horse'
      l = if @color == 'red' then '马' else '馬'
    if @name == 'elephant'
      l = if @color == 'red' then '象' else '相'
    if @name == 'knight'
      l = if @color == 'red' then '士' else '士'
    if @name == 'chief'
      l = if @color == 'red' then '将' else '帅'
    if @name == 'gun'
      l = if @color == 'red' then '炮' else '炮'
    if @name == 'soldier'
      l = if @color == 'red' then '兵' else '卒'
    l

  start_point: ->
    switch @name_symbol
      when 'carriage_l'
        if @color == 'red' then {x: 0, y: 0} else Piece.reverse_point({x: 0, y: 0})
      when 'carriage_r'
        if @color == 'red' then {x: 8, y: 0} else Piece.reverse_point({x: 8, y: 0})
      when 'horse_l'
        if @color == 'red' then {x: 1, y: 0} else Piece.reverse_point({x: 1, y: 0})
      when 'horse_r'
        if @color == 'red' then {x: 7, y: 0} else Piece.reverse_point({x: 7, y: 0})
      when 'elephant_l'
        if @color == 'red' then  {x: 2, y: 0} else Piece.reverse_point({x: 2, y: 0})
      when 'elephant_r'
        if @color == 'red' then   {x: 6, y: 0} else Piece.reverse_point({x: 6, y: 0})
      when 'knight_l'
        if @color == 'red' then {x: 3, y: 0} else Piece.reverse_point({x: 3, y: 0})
      when 'knight_r'
        if @color == 'red' then {x: 5, y: 0} else Piece.reverse_point({x: 5, y: 0})
      when 'chief'
        if @color == 'red' then {x: 4, y: 0} else Piece.reverse_point({x: 4, y: 0})
      when 'gun_l'
        if @color == 'red' then {x: 1, y: 2} else Piece.reverse_point({x: 1, y: 2})
      when 'gun_r'
        if @color == 'red' then {x: 7, y: 2} else Piece.reverse_point({x: 7, y: 2})
      when 'soldier_1'
        if @color == 'red' then {x: 0, y: 3} else Piece.reverse_point({x: 0, y: 3})
      when 'soldier_2'
        if @color == 'red' then {x: 2, y: 3} else Piece.reverse_point({x: 2, y: 3})
      when 'soldier_3'
        if @color == 'red' then  {x: 4, y: 3} else Piece.reverse_point({x: 4, y: 3})
      when 'soldier_4'
        if @color == 'red' then  {x: 6, y: 3} else Piece.reverse_point({x: 6, y: 3})
      when 'soldier_5'
        if @color == 'red' then {x: 8, y: 3} else Piece.reverse_point({x: 8, y: 3})

  moveable_points: ->
    target_points = []
    switch @name
      when 'carriage'
        for x in [0..8]
          target_points.push(new PiecePoint(x, @point.y)) if x != @point.x
        for y in [0..9]
          target_points.push(new PiecePoint(@point.x, y)) if y != @point.y


    target_points

  active: ->
    @is_selected = true

  deactive: ->
    @is_selected = false

  hover: ->
    @is_hover = true

  hout: ->
    @is_hover = false

#### Another file ####

class PiecePoint

  @clone:(point) ->
    new PiecePoint(point.x, point.y)

  constructor: (x, y) ->
    @x = x
    @y = y
    @is_hover = false
    @moveable = false
    @state = null # null means blank, it may be point to a red/black piece.

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

  mark_moveable: ->
    @moveable = true

  reset_moveable: ->
    @moveable = false

  renderTo:(ctx) ->
    if @is_hover
      ctx.beginPath()
      ctx.arc(@x_in_world(), @y_in_world(), 4, 0, 2 * Math.PI, false)
      ctx.lineWidth = 5
      ctx.strokeStyle = '#003300'
      ctx.stroke()
    if @moveable
      ctx.beginPath()
      ctx.arc(@x_in_world(), @y_in_world(), 4, 0, 2 * Math.PI, false)
      ctx.lineWidth = 5
      ctx.strokeStyle = '#FF9900'
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

#### Another file ####

class Player
  constructor: (color, name='') ->
    @color = color # red or black
    if @color == 'red'
      @name = "红方#{name}"
    else if @color == 'black'
      @name = "黑方#{name}"
    @pieces = {
      car_l      : null,
      car_r      : null,
      horse_l    : null,
      horse_r    : null,
      elephant_l : null,
      elephant_r : null,
      knight_l   : null,
      knight_r   : null,
      chief      : null,
      gun_l      : null,
      gun_r      : null,
      soldier_1  : null,
      soldier_2  : null,
      soldier_3  : null,
      soldier_4  : null,
      soldier_5  : null
    }

  alive_pieces: ->
    @pieces_array(false)

  # piece_array() return all pieces
  # piece_array(false) return all alive pieces
  pieces_array: (ignore_alive = true)->
    if ignore_alive
      return @piece_array_ignore_alive if @piece_array_ignore_alive
      @piece_array_ignore_alive = []
      for own attr, piece of @pieces
        @piece_array_ignore_alive.push piece
      return @piece_array_ignore_alive
    else
      @piece_array_alive = []
      for own attr, piece of @pieces
        @piece_array_alive.push(piece) if piece.is_alive
      return @piece_array_alive

  spawn_pieces: ->
    @pieces.car_l      = new Piece('car_l', @color)
    @pieces.car_r      = new Piece('car_r', @color)
    @pieces.horse_l    = new Piece('horse_l', @color)
    @pieces.horse_r    = new Piece('horse_r', @color)
    @pieces.elephant_l = new Piece('elephant_l', @color)
    @pieces.elephant_r = new Piece('elephant_r', @color)
    @pieces.knight_l   = new Piece('knight_l', @color)
    @pieces.knight_r   = new Piece('knight_r', @color)
    @pieces.chief      = new Piece('chief', @color)
    @pieces.gun_l      = new Piece('gun_l', @color)
    @pieces.gun_r      = new Piece('gun_r', @color)
    @pieces.soldier_1  = new Piece('soldier_1', @color)
    @pieces.soldier_2  = new Piece('soldier_2', @color)
    @pieces.soldier_3  = new Piece('soldier_3', @color)
    @pieces.soldier_4  = new Piece('soldier_4', @color)
    @pieces.soldier_5  = new Piece('soldier_5', @color)
    return @pieces_array()

window.Player = Player



#### Another file ####

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
        if @target_point
          @selected_piece.move_to_point(@target_point)
          @selected_piece.update(dt)
    return

  render: ->
    # Clear canvas first
    @ctx.fillStyle = '#FFF';
    @ctx.fillRect(0, 0, @ctx_width, @ctx_height)
    @canvas_element.width = 1
    @canvas_element.width = @ctx_width

    @drawMap()
    for points_in_columns in @points
      for point in points_in_columns
        point.renderTo(@ctx)

    for piece in @pieces
      piece.renderTo(@ctx)
    return

  constructor: (canvas_id = 'chess_game') ->
    @lastTime = Date.now()
    @canvas_element = document.getElementById(canvas_id)
    @canvasElemLeft = @canvas_element.offsetLeft
    @canvasElemTop = @canvas_element.offsetTop
    @ctx = @canvas_element.getContext('2d')
    @ctx_width = @canvas_element.width
    @ctx_height = @canvas_element.height
    @margin_top = Game.margin_top
    @margin_left = Game.margin_left

    @piece_margin = Game.piece_padding

    @columns = Game.columns
    @rows = Game.rows

    @panel_width = (@columns - 1) * @piece_margin
    @panel_height = (@rows - 1) * @piece_margin

    @points = []
    @pieces = []
    @player_red = null
    @player_black = null
    @current_player = null # current player is at bottom, enmy player is at top.
    @current_points = []
    @selected_piece = null
    @target_point = null
    Game.log("panel width: #{@panel_width}, height: #{@panel_height}")

  is_blank_point: (point) ->
    blank = true
    for piece in @pieces
      if piece.point.is_same(point)
        blank = false
        return blank
    blank

  point:(x, y) ->
    @points[x][y]

  fill_points: ->
    column_array = [0..(@columns-1)]
    row_array = [0..(@rows-1)]
    for y in row_array
      for x in column_array
        @points[x] ||= []
        @points[x].push(new PiecePoint(x, y))
    return

  init: ->
    @fill_points()
    @setupPlayers()
    @setupPieces()
    @setupEventListener()
    @main()
    return

  drawMap: ->
    # First draw 4 edge borders
    lb_point = @point(0, 0)
    rb_point = @point(8, 0)
    lt_point = @point(0, 9)
    rt_point = @point(8, 9)
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
    for y in [1..8]
      left_edge_point = @point(0, y)
      right_edge_point = @point(8, y)
      @ctx.beginPath()
      @ctx.moveTo(left_edge_point.x_in_world(), left_edge_point.y_in_world())
      @ctx.lineTo(right_edge_point.x_in_world(), right_edge_point.y_in_world())
      @ctx.stroke()

    # 3: Draw self columns
    for x in [1..7]
      b_point = @point(x, 0)
      t_point = @point(x, 4)
      @ctx.beginPath()
      @ctx.moveTo(b_point.x_in_world(), b_point.y_in_world())
      @ctx.lineTo(t_point.x_in_world(), t_point.y_in_world())
      @ctx.stroke()
    # 4: Draw enmy columns
    for x2 in [1..7]
      b2_point = @point(x2, 5)
      t2_point = @point(x2, 9)
      @ctx.beginPath()
      @ctx.moveTo(b2_point.x_in_world(), b2_point.y_in_world())
      @ctx.lineTo(t2_point.x_in_world(), t2_point.y_in_world())
      @ctx.stroke()

    # 5: Draw self house line
    s1_point = @point(3, 0)
    s11_point = @point(5, 2)
    @ctx.beginPath()
    @ctx.moveTo(s1_point.x_in_world(), s1_point.y_in_world())
    @ctx.lineTo(s11_point.x_in_world(), s11_point.y_in_world())
    @ctx.stroke()
    s2_point = @point(5, 0)
    s22_point = @point(3, 2)
    @ctx.beginPath()
    @ctx.moveTo(s2_point.x_in_world(), s2_point.y_in_world())
    @ctx.lineTo(s22_point.x_in_world(), s22_point.y_in_world())
    @ctx.stroke()
    # 6: Draw enmy house line
    s3_point = @point(3, 7)
    s33_point = @point(5, 9)
    @ctx.beginPath()
    @ctx.moveTo(s3_point.x_in_world(), s3_point.y_in_world())
    @ctx.lineTo(s33_point.x_in_world(), s33_point.y_in_world())
    @ctx.stroke()
    s4_point = @point(5, 7)
    s44_point = @point(3, 9)
    @ctx.beginPath()
    @ctx.moveTo(s4_point.x_in_world(), s4_point.y_in_world())
    @ctx.lineTo(s44_point.x_in_world(), s44_point.y_in_world())
    @ctx.stroke()
    return

  setupPlayers: ->
    @player_red = new Player('red')
    @player_black = new Player('black')
    @current_player = @player_red
    return

  setupPieces: ->
    @pieces.push.apply(@pieces, @player_red.spawn_pieces())
    @pieces.push.apply(@pieces, @player_black.spawn_pieces())
    Game.log("Piece count: #{@pieces.length}")
    return

  setupEventListener: ->
    @canvas_element.addEventListener 'mousemove', (event) =>
      x = event.pageX - @canvasElemLeft
      y = event.pageY - @canvasElemTop
      for piece in @pieces
        if x >= piece.point.x_in_world() - Game.radius && x <= piece.point.x_in_world() + Game.radius && y >= piece.point.y_in_world() - Game.radius && y <= piece.point.y_in_world() + Game.radius
          piece.hover()
        else
          piece.hout()

      for points_in_columns in @points
        for point in points_in_columns
          if x >= point.x_in_world() - Game.radius && x <= point.x_in_world() + Game.radius && y >= point.y_in_world() - Game.radius && y <= point.y_in_world() + Game.radius
            if @is_blank_point(point)
              point.hover()
          else
            point.hout()

    @canvas_element.addEventListener 'click', (event) =>
      x = event.pageX - @canvasElemLeft
      y = event.pageY - @canvasElemTop
      console.log('receive click event on canvas: ', x, y)
      for piece in @current_player.alive_pieces()
        if x >= piece.point.x_in_world() - Game.radius && x <= piece.point.x_in_world() + Game.radius && y >= piece.point.y_in_world() - Game.radius && y <= piece.point.y_in_world() + Game.radius
          piece.active()
          @selected_piece = piece
          @mark_available_target_points()
          Game.log("selected piece:#{@selected_piece.name}, x,y:#{@selected_piece.point.x},#{@selected_piece.point.y}")
        else
          piece.deactive()

      for points_in_columns in @points
        for point in points_in_columns
          if x >= point.x_in_world() - Game.radius && x <= point.x_in_world() + Game.radius && y >= point.y_in_world() - Game.radius && y <= point.y_in_world() + Game.radius
            if @is_blank_point(point)
              Game.log("Point (#{point.x},#{point.y}) is blank.")
              @target_point = PiecePoint.clone(point)
              @reset_moveable_points()
              break
    return

  reset_moveable_points: ->
    for points_in_columns in @points
      for point in points_in_columns
        point.reset_moveable()
    return

  mark_available_target_points: ->
    moveable_points = @selected_piece.moveable_points()
    Game.log("moveable points:#{moveable_points.length}")
    for points_in_columns in @points
      for point in points_in_columns
        if point.is_in(moveable_points)
          point.mark_moveable()
        else
          point.reset_moveable()
    return

$ ->
  chess_game = new Chess()
  window.t = chess_game

  chess_game.init()