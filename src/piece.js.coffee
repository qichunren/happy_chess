class Piece
  constructor: (name_symbol, color) ->
    @name_symbol = name_symbol
    @is_selected = false
    @is_hover = false
    @name = if @name_symbol.indexOf('_') > -1 then @name_symbol.split('_')[0] else @name_symbol
    @color = color
    @point = new PiecePoint(@start_point().x, @start_point().y)
    @target_point = null

  set_point:(point) ->
    @point = point

  move_to_point: (target_point) ->
    @target_point = target_point

  update: (dt) ->
    if @target_point
      if @target_point.x != @point.x
        @point.x -= 1 if @target_point.x < @point.x
        @point.x += 1 if @target_point.x > @point.x
      if @target_point.y != @point.y
        @point.y -= 1 if @target_point.y < @point.y
        @point.y += 1 if @target_point.y > @point.y
      if @target_point.x == @point.x && @target_point.y == @point.y
        @set_point(@target_point)



  renderTo:(ctx) ->
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
    ctx.fillText(@label(), @point.x_in_world(), @point.y_in_world()+10)

  label: ->
    l = null
    if @name == 'car'
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
      when 'car_l'      then {x:0,y:0}
      when 'car_r'      then {x:8,y:0}
      when 'horse_l'    then {x:1,y:0}
      when 'horse_r'    then {x:7,y:0}
      when 'elephant_l' then {x:2,y:0}
      when 'elephant_r' then {x:6,y:0}
      when 'knight_l'   then {x:3,y:0}
      when 'knight_r'   then {x:5,y:0}
      when 'chief'      then {x:4,y:0}
      when 'gun_l'      then {x:1,y:2}
      when 'gun_r'      then {x:7,y:2}
      when 'soldier_1'  then {x:0,y:3}
      when 'soldier_2'  then {x:2,y:3}
      when 'soldier_3'  then {x:4,y:3}
      when 'soldier_4'  then {x:6,y:3}
      when 'soldier_5'  then {x:8,y:3}
      when 'soldier_6'  then {x:9,y:3}

  active: ->
    @is_selected = true

  deactive: ->
    @is_selected = false

  hover: ->
    @is_hover = true

  hout: ->
    @is_hover = false