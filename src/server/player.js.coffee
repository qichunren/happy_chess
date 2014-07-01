class Player
  constructor : (name, socket) ->
    @name = name
    @socket = socket
    @id = uuid.v4()

  send_message : (message_type, message) ->
    socket.emit(message_type, data)
