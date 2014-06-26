(function() {
  var Chess, Piece, PiecePoint, requestAnimFrame,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.ChineseChess = {};

  ChineseChess.columns = 9;

  ChineseChess.rows = 10;

  ChineseChess.margin_top = 50;

  ChineseChess.margin_left = 50;

  ChineseChess.piece_padding = 60;

  ChineseChess.radius = 26;

  Piece = (function() {
    function Piece(name_symbol, color) {
      this.name_symbol = name_symbol;
      this.is_selected = false;
      this.is_hover = false;
      this.name = this.name_symbol.indexOf('_') > -1 ? this.name_symbol.split('_')[0] : this.name_symbol;
      this.color = color;
      this.point = new PiecePoint(this.start_point().x, this.start_point().y);
      this.target_point = null;
    }

    Piece.prototype.set_point = function(point) {
      return this.point = point;
    };

    Piece.prototype.move_to_point = function(target_point) {
      return this.target_point = target_point;
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
          return this.set_point(this.target_point);
        }
      }
    };

    Piece.prototype.renderTo = function(ctx) {
      ctx.beginPath();
      ctx.arc(this.point.x_in_world(), this.point.y_in_world(), ChineseChess.radius, 0, 2 * Math.PI, false);
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
      return ctx.fillText(this.label(), this.point.x_in_world(), this.point.y_in_world() + 10);
    };

    Piece.prototype.label = function() {
      var l;
      l = null;
      if (this.name === 'car') {
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
        case 'car_l':
          return {
            x: 0,
            y: 0
          };
        case 'car_r':
          return {
            x: 8,
            y: 0
          };
        case 'horse_l':
          return {
            x: 1,
            y: 0
          };
        case 'horse_r':
          return {
            x: 7,
            y: 0
          };
        case 'elephant_l':
          return {
            x: 2,
            y: 0
          };
        case 'elephant_r':
          return {
            x: 6,
            y: 0
          };
        case 'knight_l':
          return {
            x: 3,
            y: 0
          };
        case 'knight_r':
          return {
            x: 5,
            y: 0
          };
        case 'chief':
          return {
            x: 4,
            y: 0
          };
        case 'gun_l':
          return {
            x: 1,
            y: 2
          };
        case 'gun_r':
          return {
            x: 7,
            y: 2
          };
        case 'soldier_1':
          return {
            x: 0,
            y: 3
          };
        case 'soldier_2':
          return {
            x: 2,
            y: 3
          };
        case 'soldier_3':
          return {
            x: 4,
            y: 3
          };
        case 'soldier_4':
          return {
            x: 6,
            y: 3
          };
        case 'soldier_5':
          return {
            x: 8,
            y: 3
          };
        case 'soldier_6':
          return {
            x: 9,
            y: 3
          };
      }
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

  requestAnimFrame = (function() {
    return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback) {
      window.setTimeout(callback, 1000 / 60);
    };
  })();

  PiecePoint = (function() {
    function PiecePoint(x, y) {
      this.x = x;
      this.y = y;
      this.is_hover = false;
    }

    PiecePoint.prototype.x_in_world = function() {
      return this.x * ChineseChess.piece_padding + ChineseChess.margin_left;
    };

    PiecePoint.prototype.y_in_world = function() {
      return ((ChineseChess.rows - 1) - this.y) * ChineseChess.piece_padding + ChineseChess.margin_top;
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

    PiecePoint.prototype.renderTo = function(ctx) {
      if (this.is_hover) {
        ctx.beginPath();
        ctx.arc(this.x_in_world(), this.y_in_world(), 4, 0, 2 * Math.PI, false);
        ctx.lineWidth = 5;
        ctx.strokeStyle = '#003300';
        return ctx.stroke();
      }
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
      return this.x === (ChineseChess.columns - 1);
    };

    PiecePoint.prototype.is_at_self_river = function() {
      return this.y === 4;
    };

    PiecePoint.prototype.is_at_enmy_river = function() {
      return this.y === 5;
    };

    PiecePoint.prototype.toPosition = function() {
      return {
        x: this.x * ChineseChess.piece_padding,
        y: ((ChineseChess.rows - 1) - this.y) * ChineseChess.piece_padding
      };
    };

    PiecePoint.prototype.toPositionInWorld = function() {
      return {
        x: this.x * ChineseChess.piece_padding + ChineseChess.margin_left,
        y: ((ChineseChess.rows - 1) - this.y) * ChineseChess.piece_padding + ChineseChess.margin_top
      };
    };

    return PiecePoint;

  })();

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
      var piece, _i, _len, _ref, _results;
      this.current_points = [];
      _ref = this.pieces;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        piece = _ref[_i];
        this.current_points.push(piece.point);
        if (this.selected_piece === piece) {
          console.log('selected piece: ', piece.point.x, piece.point.y);
          if (this.target_point) {
            this.selected_piece.move_to_point(this.target_point);
            _results.push(this.selected_piece.update(dt));
          } else {
            _results.push(void 0);
          }
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Chess.prototype.render = function() {
      var piece, point, _i, _j, _len, _len1, _ref, _ref1, _results;
      this.ctx.fillStyle = '#FFF';
      this.ctx.fillRect(0, 0, this.ctx_width, this.ctx_height);
      this.drawMap();
      _ref = this.all_points;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        point = _ref[_i];
        point.renderTo(this.ctx);
      }
      _ref1 = this.pieces;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        piece = _ref1[_j];
        _results.push(piece.renderTo(this.ctx));
      }
      return _results;
    };

    function Chess(canvas_id) {
      if (canvas_id == null) {
        canvas_id = 'chess_game';
      }
      this.main = __bind(this.main, this);
      this.debug = true;
      this.lastTime = Date.now();
      this.canvas_element = document.getElementById(canvas_id);
      this.canvasElemLeft = this.canvas_element.offsetLeft;
      this.canvasElemTop = this.canvas_element.offsetTop;
      this.ctx = this.canvas_element.getContext('2d');
      this.ctx_width = 800;
      this.ctx_height = 600;
      this.margin_top = ChineseChess.margin_top;
      this.margin_left = ChineseChess.margin_left;
      this.piece_margin = ChineseChess.piece_padding;
      this.columns = ChineseChess.columns;
      this.rows = ChineseChess.rows;
      this.panel_width = (this.columns - 1) * this.piece_margin;
      this.panel_height = (this.rows - 1) * this.piece_margin;
      this.all_points = [];
      this.current_points = [];
      this.selected_piece = null;
      this.target_point;
      if (this.debug) {
        console.log("panel width, height: ", this.panel_width, this.panel_height);
      }
    }

    Chess.prototype.is_blank_point = function(point) {
      var found, _i, _len, _point, _ref;
      found = false;
      _ref = this.current_points;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        _point = _ref[_i];
        if (point.is_same(_point)) {
          found = true;
        }
        break;
      }
      return found === false;
    };

    Chess.prototype.point = function(x, y) {
      var point, _i, _len, _point, _ref;
      point = null;
      _ref = this.all_points;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        _point = _ref[_i];
        if (_point.x === x && _point.y === y) {
          point = _point;
          break;
        }
      }
      return point;
    };

    Chess.prototype.fill_points = function() {
      var column_array, row_array, x, y, _i, _j, _k, _len, _ref, _ref1, _results, _results1, _results2;
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
      _results2 = [];
      for (_k = 0, _len = row_array.length; _k < _len; _k++) {
        y = row_array[_k];
        _results2.push((function() {
          var _l, _len1, _results3;
          _results3 = [];
          for (_l = 0, _len1 = column_array.length; _l < _len1; _l++) {
            x = column_array[_l];
            _results3.push(this.all_points.push(new PiecePoint(x, y)));
          }
          return _results3;
        }).call(this));
      }
      return _results2;
    };

    Chess.prototype.init = function() {
      this.fill_points();
      this.setupPieces();
      this.setupEventListener();
      return this.main();
    };

    Chess.prototype.drawMap = function() {
      var b2_point, b_point, lb_point, left_edge_point, lt_point, rb_point, right_edge_point, rt_point, s11_point, s1_point, s22_point, s2_point, s33_point, s3_point, s44_point, s4_point, t2_point, t_point, _i, _j, _k, _x, _x2, _y;
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
      for (_y = _i = 1; _i <= 8; _y = ++_i) {
        left_edge_point = this.point(0, _y);
        right_edge_point = this.point(8, _y);
        this.ctx.beginPath();
        this.ctx.moveTo(left_edge_point.x_in_world(), left_edge_point.y_in_world());
        this.ctx.lineTo(right_edge_point.x_in_world(), right_edge_point.y_in_world());
        this.ctx.stroke();
      }
      for (_x = _j = 1; _j <= 7; _x = ++_j) {
        b_point = this.point(_x, 0);
        t_point = this.point(_x, 4);
        this.ctx.beginPath();
        this.ctx.moveTo(b_point.x_in_world(), b_point.y_in_world());
        this.ctx.lineTo(t_point.x_in_world(), t_point.y_in_world());
        this.ctx.stroke();
      }
      for (_x2 = _k = 1; _k <= 7; _x2 = ++_k) {
        b2_point = this.point(_x2, 5);
        t2_point = this.point(_x2, 9);
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
      return this.ctx.stroke();
    };

    Chess.prototype.setupPieces = function() {
      var name, piece, _i, _len, _ref, _results;
      this.pieces = [];
      _ref = ['car_l', 'car_r', 'horse_l', 'horse_r', 'elephant_l', 'elephant_r', 'knight_l', 'knight_r', 'chief', 'gun_l', 'gun_r', 'soldier_1', 'soldier_2', 'soldier_3', 'soldier_4', 'soldier_5'];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        name = _ref[_i];
        piece = new Piece(name, 'red');
        this.pieces.push(piece);
        _results.push(this.current_points.push(piece.point));
      }
      return _results;
    };

    Chess.prototype.setupEventListener = function() {
      this.canvas_element.addEventListener('mousemove', (function(_this) {
        return function(event) {
          var every_point, piece, x, y, _i, _j, _len, _len1, _ref, _ref1, _results;
          x = event.pageX - _this.canvasElemLeft;
          y = event.pageY - _this.canvasElemTop;
          _ref = _this.pieces;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            piece = _ref[_i];
            if (x >= piece.point.x_in_world() - ChineseChess.radius && x <= piece.point.x_in_world() + ChineseChess.radius && y >= piece.point.y_in_world() - ChineseChess.radius && y <= piece.point.y_in_world() + ChineseChess.radius) {
              piece.hover();
            } else {
              piece.hout();
            }
          }
          _ref1 = _this.all_points;
          _results = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            every_point = _ref1[_j];
            if (x >= every_point.x_in_world() - ChineseChess.radius && x <= every_point.x_in_world() + ChineseChess.radius && y >= every_point.y_in_world() - ChineseChess.radius && y <= every_point.y_in_world() + ChineseChess.radius) {
              if (_this.is_blank_point(every_point)) {
                _results.push(every_point.hover());
              } else {
                _results.push(void 0);
              }
            } else {
              _results.push(every_point.hout());
            }
          }
          return _results;
        };
      })(this));
      return this.canvas_element.addEventListener('click', (function(_this) {
        return function(event) {
          var every_point, piece, x, y, _i, _j, _len, _len1, _ref, _ref1, _results;
          x = event.pageX - _this.canvasElemLeft;
          y = event.pageY - _this.canvasElemTop;
          console.log('receive click event on canvas: ', x, y);
          _ref = _this.pieces;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            piece = _ref[_i];
            if (x >= piece.point.x_in_world() - ChineseChess.radius && x <= piece.point.x_in_world() + ChineseChess.radius && y >= piece.point.y_in_world() - ChineseChess.radius && y <= piece.point.y_in_world() + ChineseChess.radius) {
              piece.active();
              _this.selected_piece = piece;
            } else {
              piece.deactive();
            }
          }
          _ref1 = _this.all_points;
          _results = [];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            every_point = _ref1[_j];
            if (x >= every_point.x_in_world() - ChineseChess.radius && x <= every_point.x_in_world() + ChineseChess.radius && y >= every_point.y_in_world() - ChineseChess.radius && y <= every_point.y_in_world() + ChineseChess.radius) {
              if (_this.is_blank_point(every_point)) {
                _this.target_point = every_point;
                break;
              } else {
                _results.push(void 0);
              }
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        };
      })(this));
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
