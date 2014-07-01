$ ->
  socket.emit('player_login', current_user)

  socket.on 'refresh', (data) ->
    console.log 'receive refresh event: ', data
    $("#online_count").text(data.online_count)