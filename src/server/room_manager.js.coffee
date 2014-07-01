class RoomManager
  constructor: (max_rooms_count = 10) ->
    @max_rooms_count = 10
    @rooms = {}

  add_room: (room) ->
    @rooms[room.id] = room
    room.room_manager = this
    return this

  remove_room: (room) ->
    target_room = @rooms[room.id]
    target_room.room_manager = null
    delete @rooms[room.id]
    return

  get_rooms_json_array: ->
    rooms = []
    for own room_id, room of @rooms
      rooms.push {id:room.id, name:room.name, players_count: room.players.length, created_at:room.created_at }
    rooms