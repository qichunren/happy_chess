class Room
  constructor:(name) ->
    @name = name
    @id = uuid.v4()
    @players = []
    @room_manager = null
    @created_at = new Date()

  add_player: (player) ->
    # TODO

  remove_player: (player) ->
    # TODO

  get_players: ->
    @players
