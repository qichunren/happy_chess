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
  # console.log('Chess: ', message) if Game.is_debug
  if $("#debug").val() == ''
    $("#debug").val(message) if Game.is_debug
  else
    $("#debug").val($("#debug").val() + "\n" +message) if Game.is_debug