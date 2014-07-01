(function() {
  var app, bodyParser, config, cookieParser, express, fs, io, port, router, server;

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

  router.get("/", function(req, res) {
    console.log("cookies user:", req.cookies);
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

  app.use('/', router);

  server.listen(port, function() {
    console.log("Server listening at port %d", port);
  });

}).call(this);
