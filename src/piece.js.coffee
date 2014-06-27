class Piece
  @reverse_point: (p) ->
    { x: ( 8 - p.x ), y: ( 9 - p.y ) }

  constructor: (name_symbol, color) ->
    @name_symbol = name_symbol
    @name = if @name_symbol.indexOf('_') > -1 then @name_symbol.split('_')[0] else @name_symbol
    @is_alive = true
    @is_selected = false
    @is_hover = false
    @attackable = true
    @color = color
    @point = new Point(@start_point().x, @start_point().y)
    @target_point = null
    @radius = Game.radius
    @selected_color = '#BDBDBD'

  move_to_point: (target_point) ->
    @target_point = target_point
    return

  update: (dt) ->
    if @target_point
      if @target_point.x != @point.x
        @point.x -= 1 if @target_point.x < @point.x
        @point.x += 1 if @target_point.x > @point.x
      if @target_point.y != @point.y
        @point.y -= 1 if @target_point.y < @point.y
        @point.y += 1 if @target_point.y > @point.y
      if @target_point.x == @point.x && @target_point.y == @point.y
        @target_point.is_selected = false
        @is_selected = false
    return

  renderTo: (ctx) ->
#    if @attackable == true
#      ctx.beginPath()
#      ctx.arc(@point.x_in_world(), @point.y_in_world(), Game.radius+4, 0, 2 * Math.PI, false)
#      ctx.fillStyle = 'red'
#      ctx.fill()

    ctx.beginPath()
    ctx.arc(@point.x_in_world(), @point.y_in_world(), @radius, 0, 2 * Math.PI, false)
    if @attackable == true
      ctx.fillStyle = '#E9BEBE'
    else if @is_selected || @is_hover
      ctx.fillStyle =  @selected_color
    else
      ctx.fillStyle = '#EEEDDD'
    ctx.fill()
    ctx.lineWidth = 5
    ctx.strokeStyle = @color # border color
    ctx.stroke()
    ctx.font = '20pt Calibri'
    ctx.fillStyle = @color
    ctx.textAlign = 'center'
    ctx.fillText(@label(), @point.x_in_world(), @point.y_in_world() + 10)


    return

#  animate_size: ->
#    if @radius <= Game.radius
#      @radius = @radius + 0.1
#    else if @radius >= Game.radius + 3
#      @radius = @radius - 0.1
#    else
#      @radius = @radius + 0.1

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
        if @color == 'red' then {x: 2, y: 0} else Piece.reverse_point({x: 2, y: 0})
      when 'elephant_r'
        if @color == 'red' then {x: 6, y: 0} else Piece.reverse_point({x: 6, y: 0})
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
        if @color == 'red' then {x: 4, y: 3} else Piece.reverse_point({x: 4, y: 3})
      when 'soldier_4'
        if @color == 'red' then {x: 6, y: 3} else Piece.reverse_point({x: 6, y: 3})
      when 'soldier_5'
        if @color == 'red' then {x: 8, y: 3} else Piece.reverse_point({x: 8, y: 3})

  moveable_points: ->
    target_points = []
    switch @name
      when 'carriage'
        for x in [0..8]
          target_points.push(new Point(x, @point.y)) if x != @point.x
        for y in [0..9]
          target_points.push(new Point(@point.x, y)) if y != @point.y
      when 'horse' # max to 8 points
        target_points.push(new Point(@point.x+1, @point.y+2)) if @point.x+1 <= 8 && @point.y+2 <= 9
        target_points.push(new Point(@point.x+2, @point.y+1)) if @point.x+2 <= 8 && @point.y+1 <= 9
        target_points.push(new Point(@point.x+2, @point.y-1)) if @point.x+2 <= 8 && @point.y-1 >= 0
        target_points.push(new Point(@point.x+1, @point.y-2)) if @point.x+1 <= 8 && @point.y-2 >= 0
        target_points.push(new Point(@point.x-1, @point.y-2)) if @point.x-1 >= 0 && @point.y-2 >= 0
        target_points.push(new Point(@point.x-2, @point.y-1)) if @point.x-2 >= 0 && @point.y-1 >= 0
        target_points.push(new Point(@point.x-2, @point.y+1)) if @point.x-2 >= 0 && @point.y+1 <= 9
        target_points.push(new Point(@point.x-1, @point.y+2)) if @point.x-1 >= 0 && @point.y+2 <= 9
      when 'elephant' # max to 4 points
        target_points.push(new Point(@point.x-2, @point.y-2)) if @point.x-2 >= 0 && @point.y-2 >= 0
        target_points.push(new Point(@point.x-2, @point.y+2)) if @point.x-2 >= 0 && @point.y+2 <= 4
        target_points.push(new Point(@point.x+2, @point.y+2)) if @point.x+2 <= 8 && @point.y+2 <= 4
        target_points.push(new Point(@point.x+2, @point.y-2)) if @point.x+2 <= 8 && @point.y-2 >= 0
      when 'knight' # max to 4 points
        if @point.is_at(3, 0)
          target_points.push(new Point(4, 1))
        else if @point.is_at(3, 2)
          target_points.push(new Point(4, 1))
        else if @point.is_at(5, 2)
          target_points.push(new Point(4, 1))
        else if @point.is_at(5, 0)
          target_points.push(new Point(4, 1))
        else if @point.is_at(4, 1)
          target_points.push(new Point(3, 0))
          target_points.push(new Point(3, 2))
          target_points.push(new Point(5, 2))
          target_points.push(new Point(5, 0))
      when 'chief' # max to 4 points
        target_points.push(new Point(@point.x, @point.y-1)) if @point.y-1 >= 0
        target_points.push(new Point(@point.x, @point.y+1)) if @point.y+1 <= 2
        target_points.push(new Point(@point.x+1, @point.y)) if @point.x+1 <= 5
        target_points.push(new Point(@point.x-1, @point.y)) if @point.x-1 >= 3
      when 'gun'
        # todo
        []
      when 'soldier' # only one move step when not cross river. After cross river, max move points to 3
        if @point.y <= 4
          target_points.push(new Point(@point.x, @point.y+1))
        else
          target_points.push(new Point(@point.x-1, @point.y)) if @point.x-1 >= 0
          target_points.push(new Point(@point.x+1, @point.y)) if @point.x+1 <= 8
          target_points.push(new Point(@point.x, @point.y+1)) if @point.y+1 <= 9
    target_points

  active: ->
    @is_selected = true

  deactive: ->
    @is_selected = false

  hover: ->
    @is_hover = true

  hout: ->
    @is_hover = false