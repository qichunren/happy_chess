class Chess
  @defer: (callback) ->
    setTimeout ->
      callback()
    , 100
    return

  debug: ->
    for piece in @pieces
      if piece.is_selected
        console.log("[for] Selected piece is #{piece.name_symbol} (#{piece.point.x},#{piece.point.y})")
    for points_in_columns in @points
      for point in points_in_columns
        if point.is_selected
          console.log("[for] Selected point is (#{point.x},#{point.y})")
    if @selected_piece
      console.log("      Selected piece is #{@selected_piece.name_symbol} (#{@selected_piece.point.x},#{@selected_piece.point.y})")
    if @selected_point
      console.log("      Selected point is (#{@selected_point.x},#{@selected_point.y})")
    return


  main: =>
    now = Date.now()
    dt = (now - @lastTime) / 1000.0
    @update dt
    @render()
    @lastTime = now
    requestAnimFrame @main
    return

  update: (dt) ->
    if @selected_piece && @selected_point
      @selected_piece.move_to_point(@selected_point)
      @selected_piece.update(dt)
      Chess.defer =>
        @selected_piece = null
        @selected_point = null

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
      piece.renderTo(this) if piece.is_alive
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
    @selected_piece = null
    @selected_point = null
    Game.log("panel width: #{@panel_width}, height: #{@panel_height}")

  is_blank_point: (point) ->
    blank = true
    for piece in @pieces
      if piece.point.is_same(point) && piece.is_alive
        blank = false
        return blank
    blank

  point:(x, y) ->
    @points[x][y]

  # Get position (x, y) object, it may be: point, a red piece, or a black piece
  position:(x, y) ->
    point = @point(x, y)
    return point if @is_blank_point(point)
    for piece in @pieces
      if piece.point.is_same(point)
        return piece

  fill_points: ->
    column_array = [0..(@columns-1)]
    row_array = [0..(@rows-1)]
    for y in row_array
      for x in column_array
        @points[x] ||= []
        @points[x].push(new Point(x, y))
    return

  init: ->
    @fill_points()
    @setupPlayers()
    @setupPieces()
    @setupEventListener()
    @main()
    $("#debug_panel").hide() if !Game.is_debug
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
      for piece in @pieces
        if x >= piece.point.x_in_world() - Game.radius && x <= piece.point.x_in_world() + Game.radius && y >= piece.point.y_in_world() - Game.radius && y <= piece.point.y_in_world() + Game.radius
          if piece.color == @current_player.color
            @select_piece(piece)
          else
            @try_attack_piece(piece)
          Game.log("selected piece:#{piece.name}, x,y:#{piece.point.x},#{piece.point.y}")
          Game.log("Moveable points #{piece.real_moveable_points().length}")
          break

      for points_in_columns in @points
        for point in points_in_columns
          if x >= point.x_in_world() - Game.radius && x <= point.x_in_world() + Game.radius && y >= point.y_in_world() - Game.radius && y <= point.y_in_world() + Game.radius
            @select_point(point)
            break
    return

  reset_moveable_points: ->
    for points_in_columns in @points
      for point in points_in_columns
        point.reset_moveable()
    return

  try_attack_piece: (piece) ->
    return if @selected_piece == null
    moveable_points = @selected_piece.real_moveable_points()
    if piece.point.is_in(moveable_points)
      console.log('attack it!!!')
      piece.is_alive = false
      @select_point(piece.point)

  select_piece: (piece) ->
    @selected_point = null
    piece.is_selected = true
    @selected_piece = piece
    moveable_points = piece.real_moveable_points()
    Game.log("moveable points:#{moveable_points.length}")
    for piece2 in @current_player.alive_pieces()
      if piece2 != piece
        piece2.is_selected = false

    for points_in_columns in @points
      for point in points_in_columns
        point.is_selected = false
        if point.is_in(moveable_points)
          point.mark_moveable()
        else
          point.reset_moveable()
    return

  cancel_select_piece: ->
    if @selected_piece
      @selected_piece = null
      for piece in @current_player.alive_pieces()
        piece.is_selected = false

  select_point: (point) ->
    if @is_blank_point(point)
      if @selected_piece
        moveable_points = @selected_piece.real_moveable_points()
        @cancel_select_piece() if !point.is_in(moveable_points)

      point.is_selected = true
      @selected_point = point
      for points_in_columns in @points
        for point2 in points_in_columns
          if point2 != point
            point2.is_selected = false
      @reset_moveable_points()
    return



$ ->
  chess_game = new Chess()
  window.game = chess_game # Use game.debug() to print debug info in browser console.

  chess_game.init()