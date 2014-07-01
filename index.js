(function() {
  var Player, Room, RoomManager, app, bodyParser, config, cookieParser, express, fs, io, port, room, room2, room_manager, router, server, uuid, _,
    __hasProp = {}.hasOwnProperty;

  _ = require("underscore");

  uuid = require('node-uuid');

  Room = (function() {
    function Room(name) {
      this.name = name;
      this.id = uuid.v4();
      this.players = [];
      this.room_manager = null;
      this.created_at = new Date();
    }

    Room.prototype.add_player = function(player) {};

    Room.prototype.remove_player = function(player) {};

    Room.prototype.get_players = function() {
      return this.players;
    };

    return Room;

  })();

  Player = (function() {
    function Player(name, socket) {
      this.name = name;
      this.socket = socket;
      this.id = uuid.v4();
    }

    Player.prototype.send_message = function(message_type, message) {
      return socket.emit(message_type, data);
    };

    return Player;

  })();

  RoomManager = (function() {
    function RoomManager(max_rooms_count) {
      if (max_rooms_count == null) {
        max_rooms_count = 10;
      }
      this.max_rooms_count = 10;
      this.rooms = {};
    }

    RoomManager.prototype.add_room = function(room) {
      this.rooms[room.id] = room;
      room.room_manager = this;
      return this;
    };

    RoomManager.prototype.remove_room = function(room) {
      var target_room;
      target_room = this.rooms[room.id];
      target_room.room_manager = null;
      delete this.rooms[room.id];
    };

    RoomManager.prototype.get_rooms_json_array = function() {
      var room, room_id, rooms, _ref;
      rooms = [];
      _ref = this.rooms;
      for (room_id in _ref) {
        if (!__hasProp.call(_ref, room_id)) continue;
        room = _ref[room_id];
        rooms.push({
          id: room.id,
          name: room.name,
          players_count: room.players.length,
          created_at: room.created_at
        });
      }
      return rooms;
    };

    return RoomManager;

  })();

  bodyParser = require('body-parser');

  cookieParser = require('cookie-parser');

  express = require("express");

  app = express();

  router = express.Router();

  config = require("./config");

  server = require("http").createServer(app);

  port = process.env.PORT || 3003;

  io = require("socket.io").listen(server);

  fs = require("fs");

  app.set("views", "./views/pages");

  app.set("view engine", "jade");

  app.use(bodyParser.json());

  app.use(bodyParser.urlencoded({
    extended: true
  }));

  app.use(cookieParser('qichunren'));

  app.use(express["static"](__dirname + "/public"));

  room_manager = new RoomManager(5);

  room = new Room("TEST Room 1");

  room2 = new Room("TEST Room 2");

  room_manager.add_room(room);

  room_manager.add_room(room2);

  console.log("rooms:", room_manager.get_rooms_json_array());

  router.get("/", function(req, res) {
    if (req.cookies.user) {
      res.render("index", {
        title: "Happy Chess Game",
        username: req.cookies.user,
        socketurl: config.serverurl + ":" + port
      });
    } else {
      res.redirect('/signin');
    }
  });

  router.get("/signin", function(req, res) {
    res.render("signin");
  });

  router.post("/signin", function(req, res) {
    res.cookie('user', req.param('username'));
    console.log("req.param('username')", req.param('username'));
    console.log(req.body);
    res.redirect('/');
  });

  router.get("/api/rooms.json", function(req, res) {
    return res.json(room_manager.get_rooms_json_array());
  });

  app.use('/', router);

  server.listen(port, function() {
    console.log("Server listening at port %d", port);
  });

}).call(this);
