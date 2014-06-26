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

