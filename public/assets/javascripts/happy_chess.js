(function() {
  var Chess, Piece, PiecePoint, Player, requestAnimFrame,
    __hasProp = {}.hasOwnProperty,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  requestAnimFrame = (function() {
    return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback) {
      window.setTimeout(callback, 1000 / 60);
    };
  })();

  window.Game = {};

  Game.columns = 9;

  Game.rows = 10;

  Game.margin_top = 50;

  Game.margin_left = 50;

  Game.piece_padding = 60;

  Game.radius = 26;

  Game.is_debug = true;

  Game.log = function(message) {
    if ($("#debug").val() === '') {
      if (Game.is_debug) {
        return $("#debug").val(message);
      }
    } else {
      if (Game.is_debug) {
        return $("#debug").val($("#debug").val() + "\n" + message);
      }
    }
  };

  Piece = (function() {
    Piece.reverse_point = function(p) {
      return {
        x: 8 - p.x,
        y: 9 - p.y
      };
    };

    function Piece(name_symbol, color) {
      this.name_symbol = name_symbol;
      this.name = this.name_symbol.indexOf('_') > -1 ? this.name_symbol.split('_')[0] : this.name_symbol;
      this.is_alive = true;
      this.is_selected = false;
      this.is_hover = false;
      this.color = color;
      this.point = new PiecePoint(this.start_point().x, this.start_point().y);
      this.target_point = null;
    }

    Piece.prototype.set_point = function(point) {
      return this.point = point;
    };

    Piece.prototype.move_to_point = function(target_point) {
      this.target_point = PiecePoint.clone(target_point);
      target_point = null;
    };

    Piece.prototype.update = function(dt) {
      if (this.target_point) {
        if (this.target_point.x !== this.point.x) {
          if (this.target_point.x < this.point.x) {
            this.point.x -= 1;
          }
          if (this.target_point.x > this.point.x) {
            this.point.x += 1;
          }
        }
        if (this.target_point.y !== this.point.y) {
          if (this.target_point.y < this.point.y) {
            this.point.y -= 1;
          }
          if (this.target_point.y > this.point.y) {
            this.point.y += 1;
          }
        }
        if (this.target_point.x === this.point.x && this.target_point.y === this.point.y) {
          this.target_point = null;
          this.deactive();
        }
      }
    };

    Piece.prototype.renderTo = function(ctx) {
      ctx.beginPath();
      ctx.arc(this.point.x_in_world(), this.point.y_in_world(), Game.radius, 0, 2 * Math.PI, false);
      ctx.fillStyle = this.color;
      ctx.fill();
      ctx.lineWidth = 5;
      if (this.is_selected) {
        ctx.strokeStyle = '#FF9900';
      } else {
        if (this.is_hover) {
          ctx.strokeStyle = '#BDBDBD';
        } else {
          ctx.strokeStyle = '#003300';
        }
      }
      ctx.stroke();
      ctx.font = '20pt Calibri';
      ctx.fillStyle = '#FFF';
      ctx.textAlign = 'center';
      ctx.fillText(this.label(), this.point.x_in_world(), this.point.y_in_world() + 10);
    };

    Piece.prototype.label = function() {
      var l;
      l = null;
      if (this.name === 'carriage') {
        l = this.color === 'red' ? '车' : '車';
      }
      if (this.name === 'horse') {
        l = this.color === 'red' ? '马' : '馬';
      }
      if (this.name === 'elephant') {
        l = this.color === 'red' ? '象' : '相';
      }
      if (this.name === 'knight') {
        l = this.color === 'red' ? '士' : '士';
      }
      if (this.name === 'chief') {
        l = this.color === 'red' ? '将' : '帅';
      }
      if (this.name === 'gun') {
        l = this.color === 'red' ? '炮' : '炮';
      }
      if (this.name === 'soldier') {
        l = this.color === 'red' ? '兵' : '卒';
      }
      return l;
    };

    Piece.prototype.start_point = function() {
      switch (this.name_symbol) {
        case 'carriage_l':
          if (this.color === 'red') {
            return {
              x: 0,
              y: 0
            };
          } else {
            return Piece.reverse_point({
              x: 0,
              y: 0
            });
          }
          break;
        case 'carriage_r':
          if (this.color === 'red') {
            return {
              x: 8,
              y: 0
            };
          } else {
            return Piece.reverse_point({
              x: 8,
              y: 0
            });
          }
          break;
        case 'horse_l':
          if (this.color === 'red') {
            return {
              x: 1,
              y: 0
            };
          } else {
            return Piece.reverse_point({
              x: 1,
              y: 0
            });
          }
          break;
        case 'horse_r':
          if (this.color === 'red') {
            return {
              x: 7,
              y: 0
            };
          } else {
            return Piece.reverse_point({
              x: 7,
              y: 0
            });
          }
          break;
        case 'elephant_l':
          if (this.color === 'red') {
            return {
              x: 2,
              y: 0
            };
          } else {
            return Piece.reverse_point({
              x: 2,
              y: 0
            });
          }
          break;
        case 'elephant_r':
          if (this.color === 'red') {
            return {
              x: 6,
              y: 0
            };
          } else {
            return Piece.reverse_point({
              x: 6,
              y: 0
            });
          }
          break;
        case 'knight_l':
          if (this.color === 'red') {
            return {
              x: 3,
              y: 0
            };
          } else {
            return Piece.reverse_point({
              x: 3,
              y: 0
            });
          }
          break;
        case 'knight_r':
          if (this.color === 'red') {
            return {
              x: 5,
              y: 0
            };
          } else {
            return Piece.reverse_point({
              x: 5,
              y: 0
            });
          }
          break;
        case 'chief':
          if (this.color === 'red') {
            return {
              x: 4,
              y: 0
            };
          } else {
            return Piece.reverse_point({
              x: 4,
              y: 0
            });
          }
          break;
        case 'gun_l':
          if (this.color === 'red') {
            return {
              x: 1,
              y: 2
            };
          } else {
            return Piece.reverse_point({
              x: 1,
              y: 2
            });
          }
          break;
        case 'gun_r':
          if (this.color === 'red') {
            return {
              x: 7,
              y: 2
            };
          } else {
            return Piece.reverse_point({
              x: 7,
              y: 2
            });
          }
          break;
        case 'soldier_1':
          if (this.color === 'red') {
            return {
              x: 0,
              y: 3
            };
          } else {
            return Piece.reverse_point({
              x: 0,
              y: 3
            });
          }
          break;
        case 'soldier_2':
          if (this.color === 'red') {
            return {
              x: 2,
              y: 3
            };
          } else {
            return Piece.reverse_point({
              x: 2,
              y: 3
            });
          }
          break;
        case 'soldier_3':
          if (this.color === 'red') {
            return {
              x: 4,
              y: 3
            };
          } else {
            return Piece.reverse_point({
              x: 4,
              y: 3
            });
          }
          break;
        case 'soldier_4':
          if (this.color === 'red') {
            return {
              x: 6,
              y: 3
            };
          } else {
            return Piece.reverse_point({
              x: 6,
              y: 3
            });
          }
          break;
        case 'soldier_5':
          if (this.color === 'red') {
            return {
              x: 8,
              y: 3
            };
          } else {
            return Piece.reverse_point({
              x: 8,
              y: 3
            });
          }
      }
    };

    Piece.prototype.moveable_points = function() {
      var target_points, x, y, _i, _j;
      target_points = [];
      switch (this.name) {
        case 'carriage':
          for (x = _i = 0; _i <= 8; x = ++_i) {
            if (x !== this.point.x) {
              target_points.push(new PiecePoint(x, this.point.y));
            }
          }
          for (y = _j = 0; _j <= 9; y = ++_j) {
            if (y !== this.point.y) {
              target_points.push(new PiecePoint(this.point.x, y));
            }
          }
          break;
        case 'horse':
          if (this.point.x + 1 <= 8 && this.point.y + 2 <= 9) {
            target_points.push(new PiecePoint(this.point.x + 1, this.point.y + 2));
          }
          if (this.point.x + 2 <= 8 && this.point.y + 1 <= 9) {
            target_points.push(new PiecePoint(this.point.x + 2, this.point.y + 1));
          }
          if (this.point.x + 2 <= 8 && this.point.y - 1 >= 0) {
            target_points.push(new PiecePoint(this.point.x + 2, this.point.y - 1));
          }
          if (this.point.x + 1 <= 8 && this.point.y - 2 >= 0) {
            target_points.push(new PiecePoint(this.point.x + 1, this.point.y - 2));
          }
          if (this.point.x - 1 >= 0 && this.point.y - 2 >= 0) {
            target_points.push(new PiecePoint(this.point.x - 1, this.point.y - 2));
          }
          if (this.point.x - 2 >= 0 && this.point.y - 1 >= 0) {
            target_points.push(new PiecePoint(this.point.x - 2, this.point.y - 1));
          }
          if (this.point.x - 2 >= 0 && this.point.y + 1 <= 9) {
            target_points.push(new PiecePoint(this.point.x - 2, this.point.y + 1));
          }
          if (this.point.x - 1 >= 0 && this.point.y + 2 <= 9) {
            target_points.push(new PiecePoint(this.point.x - 1, this.point.y + 2));
          }
          break;
        case 'elephant':
          if (this.point.x - 2 >= 0 && this.point.y - 2 >= 0) {
            target_points.push(new PiecePoint(this.point.x - 2, this.point.y - 2));
          }
          if (this.point.x - 2 >= 0 && this.point.y + 2 <= 4) {
            target_points.push(new PiecePoint(this.point.x - 2, this.point.y + 2));
          }
          if (this.point.x + 2 <= 8 && this.point.y + 2 <= 4) {
            target_points.push(new PiecePoint(this.point.x + 2, this.point.y + 2));
          }
          if (this.point.x + 2 <= 8 && this.point.y - 2 >= 0) {
            target_points.push(new PiecePoint(this.point.x + 2, this.point.y - 2));
          }
          break;
        case 'knight':
          if (this.point.is_at(3, 0)) {
            target_points.push(new PiecePoint(4, 1));
          } else if (this.point.is_at(3, 2)) {
            target_points.push(new PiecePoint(4, 1));
          } else if (this.point.is_at(5, 2)) {
            target_points.push(new PiecePoint(4, 1));
          } else if (this.point.is_at(5, 0)) {
            target_points.push(new PiecePoint(4, 1));
          } else if (this.point.is_at(4, 1)) {
            target_points.push(new PiecePoint(3, 0));
            target_points.push(new PiecePoint(3, 2));
            target_points.push(new PiecePoint(5, 2));
            target_points.push(new PiecePoint(5, 0));
          }
          break;
        case 'chief':
          if (this.point.x - 1 >= 3 && this.point.y - 1 >= 0) {
            target_points.push(new PiecePoint(this.point.x - 1, this.point.y - 1));
          }
          if (this.point.x - 1 >= 3 && this.point.y + 1 <= 2) {
            target_points.push(new PiecePoint(this.point.x - 1, this.point.y + 1));
          }
          if (this.point.x + 1 <= 5 && this.point.y + 1 <= 2) {
            target_points.push(new PiecePoint(this.point.x + 1, this.point.y + 1));
          }
          if (this.point.x + 1 <= 5 && this.point.y - 1 >= 0) {
            target_points.push(new PiecePoint(this.point.x + 1, this.point.y - 1));
          }
          break;
        case 'gun':
          [];
          break;
        case 'soldier':
          if (this.point.y <= 4) {
            target_points.push(new PiecePoint(this.point.x, this.point.y + 1));
          } else {
            if (this.point.x - 1 >= 0) {
              target_points.push(new PiecePoint(this.point.x - 1, this.point.y));
            }
            if (this.point.x + 1 <= 8) {
              target_points.push(new PiecePoint(this.point.x + 1, this.point.y));
            }
            if (this.point.y + 1 <= 9) {
              target_points.push(new PiecePoint(this.point.x, this.point.y + 1));
            }
          }
      }
      return target_points;
    };

    Piece.prototype.active = function() {
      return this.is_selected = true;
    };

    Piece.prototype.deactive = function() {
      return this.is_selected = false;
    };

    Piece.prototype.hover = function() {
      return this.is_hover = true;
    };

    Piece.prototype.hout = function() {
      return this.is_hover = false;
    };

    return Piece;

  })();

  PiecePoint = (function() {
    PiecePoint.clone = function(point) {
      return new PiecePoint(point.x, point.y);
    };

    function PiecePoint(x, y) {
      this.x = x;
      this.y = y;
      this.is_hover = false;
      this.moveable = false;
      this.state = null;
    }

    PiecePoint.prototype.x_in_world = function() {
      return this.x * Game.piece_padding + Game.margin_left;
    };

    PiecePoint.prototype.y_in_world = function() {
      return ((Game.rows - 1) - this.y) * Game.piece_padding + Game.margin_top;
    };

    PiecePoint.prototype.is_at = function(x, y) {
      return this.x === x && this.y === y;
    };

    PiecePoint.prototype.is_same = function(other) {
      return this.x === other.x && this.y === other.y;
    };

    PiecePoint.prototype.hover = function() {
      return this.is_hover = true;
    };

    PiecePoint.prototype.hout = function() {
      return this.is_hover = false;
    };

    PiecePoint.prototype.mark_moveable = function() {
      return this.moveable = true;
    };

    PiecePoint.prototype.reset_moveable = function() {
      return this.moveable = false;
    };

    PiecePoint.prototype.renderTo = function(ctx) {
      if (this.is_hover) {
        ctx.beginPath();
        ctx.arc(this.x_in_world(), this.y_in_world(), 4, 0, 2 * Math.PI, false);
        ctx.lineWidth = 5;
        ctx.strokeStyle = '#003300';
        ctx.stroke();
      }
      if (this.moveable) {
        ctx.beginPath();
        ctx.arc(this.x_in_world(), this.y_in_world(), 4, 0, 2 * Math.PI, false);
        ctx.lineWidth = 5;
        ctx.strokeStyle = '#FF9900';
        return ctx.stroke();
      }
    };

    PiecePoint.prototype.is_in = function(points) {
      var is_include, point, _i, _len;
      is_include = false;
      for (_i = 0, _len = points.length; _i < _len; _i++) {
        point = points[_i];
        if (this.is_same(point)) {
          is_include = true;
          return is_include;
        }
      }
      return is_include;
    };

    PiecePoint.prototype.is_at_top_edge = function() {
      return this.y === 9;
    };

    PiecePoint.prototype.is_at_bottom = function() {
      return this.y === 0;
    };

    PiecePoint.prototype.is_at_left_edge = function() {
      return this.x === 0;
    };

    PiecePoint.prototype.is_at_right_edge = function() {
      return this.x === (Game.columns - 1);
    };

    PiecePoint.prototype.is_at_self_river = function() {
      return this.y === 4;
    };

    PiecePoint.prototype.is_at_enmy_river = function() {
      return this.y === 5;
    };

    PiecePoint.prototype.toPosition = function() {
      return {
        x: this.x * Game.piece_padding,
        y: ((Game.rows - 1) - this.y) * Game.piece_padding
      };
    };

    PiecePoint.prototype.toPositionInWorld = function() {
      return {
        x: this.x * Game.piece_padding + Game.margin_left,
        y: ((Game.rows - 1) - this.y) * Game.piece_padding + Game.margin_top
      };
    };

    return PiecePoint;

  })();

  Player = (function() {
    function Player(color, name) {
      if (name == null) {
        name = '';
      }
      this.color = color;
      if (this.color === 'red') {
        this.name = "红方" + name;
      } else if (this.color === 'black') {
        this.name = "黑方" + name;
      }
      this.pieces = {
        carriage_l: null,
        carriage_r: null,
        horse_l: null,
        horse_r: null,
        elephant_l: null,
        elephant_r: null,
        knight_l: null,
        knight_r: null,
        chief: null,
        gun_l: null,
        gun_r: null,
        soldier_1: null,
        soldier_2: null,
        soldier_3: null,
        soldier_4: null,
        soldier_5: null
      };
    }

    Player.prototype.alive_pieces = function() {
      return this.pieces_array(false);
    };

    Player.prototype.pieces_array = function(ignore_alive) {
      var attr, piece, _ref, _ref1;
      if (ignore_alive == null) {
        ignore_alive = true;
      }
      if (ignore_alive) {
        if (this.piece_array_ignore_alive) {
          return this.piece_array_ignore_alive;
        }
        this.piece_array_ignore_alive = [];
        _ref = this.pieces;
        for (attr in _ref) {
          if (!__hasProp.call(_ref, attr)) continue;
          piece = _ref[attr];
          this.piece_array_ignore_alive.push(piece);
        }
        return this.piece_array_ignore_alive;
      } else {
        this.piece_array_alive = [];
        _ref1 = this.pieces;
        for (attr in _ref1) {
          if (!__hasProp.call(_ref1, attr)) continue;
          piece = _ref1[attr];
          if (piece.is_alive) {
            this.piece_array_alive.push(piece);
          }
        }
        return this.piece_array_alive;
      }
    };

    Player.prototype.spawn_pieces = function() {
      this.pieces.carriage_l = new Piece('carriage_l', this.color);
      this.pieces.carriage_r = new Piece('carriage_r', this.color);
      this.pieces.horse_l = new Piece('horse_l', this.color);
      this.pieces.horse_r = new Piece('horse_r', this.color);
      this.pieces.elephant_l = new Piece('elephant_l', this.color);
      this.pieces.elephant_r = new Piece('elephant_r', this.color);
      this.pieces.knight_l = new Piece('knight_l', this.color);
      this.pieces.knight_r = new Piece('knight_r', this.color);
      this.pieces.chief = new Piece('chief', this.color);
      this.pieces.gun_l = new Piece('gun_l', this.color);
      this.pieces.gun_r = new Piece('gun_r', this.color);
      this.pieces.soldier_1 = new Piece('soldier_1', this.color);
      this.pieces.soldier_2 = new Piece('soldier_2', this.color);
      this.pieces.soldier_3 = new Piece('soldier_3', this.color);
      this.pieces.soldier_4 = new Piece('soldier_4', this.color);
      this.pieces.soldier_5 = new Piece('soldier_5', this.color);
      return this.pieces_array();
    };

    return Player;

  })();

  window.Player = Player;

  Chess = (function() {
    Chess.prototype.main = function() {
      var dt, now;
      now = Date.now();
      dt = (now - this.lastTime) / 1000.0;
      this.update(dt);
      this.render();
      this.lastTime = now;
      requestAnimFrame(this.main);
    };

    Chess.prototype.update = function(dt) {
      var piece, _i, _len, _ref;
      this.current_points = [];
      _ref = this.pieces;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        piece = _ref[_i];
        this.current_points.push(piece.point);
        if (this.selected_piece === piece) {
          if (this.target_point) {
            this.selected_piece.move_to_point(this.target_point);
            this.selected_piece.update(dt);
            this.selected_piece = null;
          }
        }
      }
    };

    Chess.prototype.render = function() {
      var piece, point, points_in_columns, _i, _j, _k, _len, _len1, _len2, _ref, _ref1;
      this.ctx.fillStyle = '#FFF';
      this.ctx.fillRect(0, 0, this.ctx_width, this.ctx_height);
      this.canvas_element.width = 1;
      this.canvas_element.width = this.ctx_width;
      this.drawMap();
      _ref = this.points;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        points_in_columns = _ref[_i];
        for (_j = 0, _len1 = points_in_columns.length; _j < _len1; _j++) {
          point = points_in_columns[_j];
          point.renderTo(this.ctx);
        }
      }
      _ref1 = this.pieces;
      for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
        piece = _ref1[_k];
        piece.renderTo(this.ctx);
      }
    };

    function Chess(canvas_id) {
      if (canvas_id == null) {
        canvas_id = 'chess_game';
      }
      this.main = __bind(this.main, this);
      this.lastTime = Date.now();
      this.canvas_element = document.getElementById(canvas_id);
      this.canvasElemLeft = this.canvas_element.offsetLeft;
      this.canvasElemTop = this.canvas_element.offsetTop;
      this.ctx = this.canvas_element.getContext('2d');
      this.ctx_width = this.canvas_element.width;
      this.ctx_height = this.canvas_element.height;
      this.margin_top = Game.margin_top;
      this.margin_left = Game.margin_left;
      this.piece_margin = Game.piece_padding;
      this.columns = Game.columns;
      this.rows = Game.rows;
      this.panel_width = (this.columns - 1) * this.piece_margin;
      this.panel_height = (this.rows - 1) * this.piece_margin;
      this.points = [];
      this.pieces = [];
      this.player_red = null;
      this.player_black = null;
      this.current_player = null;
      this.current_points = [];
      this.selected_piece = null;
      this.target_point = null;
      Game.log("panel width: " + this.panel_width + ", height: " + this.panel_height);
    }

    Chess.prototype.is_blank_point = function(point) {
      var blank, piece, _i, _len, _ref;
      blank = true;
      _ref = this.pieces;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        piece = _ref[_i];
        if (piece.point.is_same(point)) {
          blank = false;
          return blank;
        }
      }
      return blank;
    };

    Chess.prototype.point = function(x, y) {
      return this.points[x][y];
    };

    Chess.prototype.fill_points = function() {
      var column_array, row_array, x, y, _base, _i, _j, _k, _l, _len, _len1, _ref, _ref1, _results, _results1;
      column_array = (function() {
        _results = [];
        for (var _i = 0, _ref = this.columns - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this);
      row_array = (function() {
        _results1 = [];
        for (var _j = 0, _ref1 = this.rows - 1; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; 0 <= _ref1 ? _j++ : _j--){ _results1.push(_j); }
        return _results1;
      }).apply(this);
      for (_k = 0, _len = row_array.length; _k < _len; _k++) {
        y = row_array[_k];
        for (_l = 0, _len1 = column_array.length; _l < _len1; _l++) {
          x = column_array[_l];
          (_base = this.points)[x] || (_base[x] = []);
          this.points[x].push(new PiecePoint(x, y));
        }
      }
    };

    Chess.prototype.init = function() {
      this.fill_points();
      this.setupPlayers();
      this.setupPieces();
      this.setupEventListener();
      this.main();
      if (!Game.is_debug) {
        $("#debug_panel").hide();
      }
    };

    Chess.prototype.drawMap = function() {
      var b2_point, b_point, lb_point, left_edge_point, lt_point, rb_point, right_edge_point, rt_point, s11_point, s1_point, s22_point, s2_point, s33_point, s3_point, s44_point, s4_point, t2_point, t_point, x, x2, y, _i, _j, _k;
      lb_point = this.point(0, 0);
      rb_point = this.point(8, 0);
      lt_point = this.point(0, 9);
      rt_point = this.point(8, 9);
      this.ctx.beginPath();
      this.ctx.strokeStyle = '#000000';
      this.ctx.lineWidth = 4;
      this.ctx.moveTo(lb_point.x_in_world(), lb_point.y_in_world());
      this.ctx.lineTo(lt_point.x_in_world(), lt_point.y_in_world());
      this.ctx.stroke();
      this.ctx.beginPath();
      this.ctx.moveTo(lt_point.x_in_world(), lt_point.y_in_world());
      this.ctx.lineTo(rt_point.x_in_world(), rt_point.y_in_world());
      this.ctx.stroke();
      this.ctx.beginPath();
      this.ctx.moveTo(rt_point.x_in_world(), rt_point.y_in_world());
      this.ctx.lineTo(rb_point.x_in_world(), rb_point.y_in_world());
      this.ctx.stroke();
      this.ctx.beginPath();
      this.ctx.moveTo(rb_point.x_in_world(), rb_point.y_in_world());
      this.ctx.lineTo(lb_point.x_in_world(), lb_point.y_in_world());
      this.ctx.stroke();
      this.ctx.strokeStyle = '#BDBDBD';
      this.ctx.lineWidth = 1;
      for (y = _i = 1; _i <= 8; y = ++_i) {
        left_edge_point = this.point(0, y);
        right_edge_point = this.point(8, y);
        this.ctx.beginPath();
        this.ctx.moveTo(left_edge_point.x_in_world(), left_edge_point.y_in_world());
        this.ctx.lineTo(right_edge_point.x_in_world(), right_edge_point.y_in_world());
        this.ctx.stroke();
      }
      for (x = _j = 1; _j <= 7; x = ++_j) {
        b_point = this.point(x, 0);
        t_point = this.point(x, 4);
        this.ctx.beginPath();
        this.ctx.moveTo(b_point.x_in_world(), b_point.y_in_world());
        this.ctx.lineTo(t_point.x_in_world(), t_point.y_in_world());
        this.ctx.stroke();
      }
      for (x2 = _k = 1; _k <= 7; x2 = ++_k) {
        b2_point = this.point(x2, 5);
        t2_point = this.point(x2, 9);
        this.ctx.beginPath();
        this.ctx.moveTo(b2_point.x_in_world(), b2_point.y_in_world());
        this.ctx.lineTo(t2_point.x_in_world(), t2_point.y_in_world());
        this.ctx.stroke();
      }
      s1_point = this.point(3, 0);
      s11_point = this.point(5, 2);
      this.ctx.beginPath();
      this.ctx.moveTo(s1_point.x_in_world(), s1_point.y_in_world());
      this.ctx.lineTo(s11_point.x_in_world(), s11_point.y_in_world());
      this.ctx.stroke();
      s2_point = this.point(5, 0);
      s22_point = this.point(3, 2);
      this.ctx.beginPath();
      this.ctx.moveTo(s2_point.x_in_world(), s2_point.y_in_world());
      this.ctx.lineTo(s22_point.x_in_world(), s22_point.y_in_world());
      this.ctx.stroke();
      s3_point = this.point(3, 7);
      s33_point = this.point(5, 9);
      this.ctx.beginPath();
      this.ctx.moveTo(s3_point.x_in_world(), s3_point.y_in_world());
      this.ctx.lineTo(s33_point.x_in_world(), s33_point.y_in_world());
      this.ctx.stroke();
      s4_point = this.point(5, 7);
      s44_point = this.point(3, 9);
      this.ctx.beginPath();
      this.ctx.moveTo(s4_point.x_in_world(), s4_point.y_in_world());
      this.ctx.lineTo(s44_point.x_in_world(), s44_point.y_in_world());
      this.ctx.stroke();
    };

    Chess.prototype.setupPlayers = function() {
      this.player_red = new Player('red');
      this.player_black = new Player('black');
      this.current_player = this.player_red;
    };

    Chess.prototype.setupPieces = function() {
      this.pieces.push.apply(this.pieces, this.player_red.spawn_pieces());
      this.pieces.push.apply(this.pieces, this.player_black.spawn_pieces());
      Game.log("Piece count: " + this.pieces.length);
    };

    Chess.prototype.setupEventListener = function() {
      this.canvas_element.addEventListener('mousemove', (function(_this) {
        return function(event) {
          var piece, point, points_in_columns, x, y, _i, _j, _len, _len1, _ref, _ref1, _results;
          x = event.pageX - _this.canvasElemLeft;
          y = event.pageY - _this.canvasElemTop;
          _ref = _this.pieces;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            piece = _ref[_i];
            if (x >= piece.point.x_in_world() - Game.radius && x <= piece.point.x_in_world() + Game.radius && y >= piece.point.y_in_world() - Game.radius && y <= piece.point.y_in_world() + Game.radius) {
              piece.hover();
            } else {
              piece.hout();
            }
          }
          _ref1 = _this.points;
          _results = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            points_in_columns = _ref1[_j];
            _results.push((function() {
              var _k, _len2, _results1;
              _results1 = [];
              for (_k = 0, _len2 = points_in_columns.length; _k < _len2; _k++) {
                point = points_in_columns[_k];
                if (x >= point.x_in_world() - Game.radius && x <= point.x_in_world() + Game.radius && y >= point.y_in_world() - Game.radius && y <= point.y_in_world() + Game.radius) {
                  if (this.is_blank_point(point)) {
                    _results1.push(point.hover());
                  } else {
                    _results1.push(void 0);
                  }
                } else {
                  _results1.push(point.hout());
                }
              }
              return _results1;
            }).call(_this));
          }
          return _results;
        };
      })(this));
      this.canvas_element.addEventListener('click', (function(_this) {
        return function(event) {
          var piece, point, points_in_columns, x, y, _i, _j, _len, _len1, _ref, _ref1, _results;
          x = event.pageX - _this.canvasElemLeft;
          y = event.pageY - _this.canvasElemTop;
          console.log('receive click event on canvas: ', x, y);
          _ref = _this.current_player.alive_pieces();
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            piece = _ref[_i];
            if (x >= piece.point.x_in_world() - Game.radius && x <= piece.point.x_in_world() + Game.radius && y >= piece.point.y_in_world() - Game.radius && y <= piece.point.y_in_world() + Game.radius) {
              piece.active();
              _this.selected_piece = piece;
              _this.mark_available_target_points();
              _this.target_point = null;
              Game.log("selected piece:" + _this.selected_piece.name + ", x,y:" + _this.selected_piece.point.x + "," + _this.selected_piece.point.y);
            } else {
              piece.deactive();
            }
          }
          _ref1 = _this.points;
          _results = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            points_in_columns = _ref1[_j];
            _results.push((function() {
              var _k, _len2, _results1;
              _results1 = [];
              for (_k = 0, _len2 = points_in_columns.length; _k < _len2; _k++) {
                point = points_in_columns[_k];
                if (x >= point.x_in_world() - Game.radius && x <= point.x_in_world() + Game.radius && y >= point.y_in_world() - Game.radius && y <= point.y_in_world() + Game.radius) {
                  if (this.is_blank_point(point)) {
                    Game.log("Point (" + point.x + "," + point.y + ") is blank.");
                    this.target_point = PiecePoint.clone(point);
                    this.reset_moveable_points();
                    break;
                  } else {
                    _results1.push(void 0);
                  }
                } else {
                  _results1.push(void 0);
                }
              }
              return _results1;
            }).call(_this));
          }
          return _results;
        };
      })(this));
    };

    Chess.prototype.reset_moveable_points = function() {
      var point, points_in_columns, _i, _j, _len, _len1, _ref;
      _ref = this.points;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        points_in_columns = _ref[_i];
        for (_j = 0, _len1 = points_in_columns.length; _j < _len1; _j++) {
          point = points_in_columns[_j];
          point.reset_moveable();
        }
      }
    };

    Chess.prototype.mark_available_target_points = function() {
      var moveable_points, point, points_in_columns, _i, _j, _len, _len1, _ref;
      moveable_points = this.selected_piece.moveable_points();
      Game.log("moveable points:" + moveable_points.length);
      _ref = this.points;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        points_in_columns = _ref[_i];
        for (_j = 0, _len1 = points_in_columns.length; _j < _len1; _j++) {
          point = points_in_columns[_j];
          if (point.is_in(moveable_points)) {
            point.mark_moveable();
          } else {
            point.reset_moveable();
          }
        }
      }
    };

    return Chess;

  })();

  $(function() {
    var chess_game;
    chess_game = new Chess();
    window.t = chess_game;
    return chess_game.init();
  });

}).call(this);
