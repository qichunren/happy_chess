(function() {
  var app, config, express, fs, io, port, server;

  express = require("express");

  app = express();

  config = require("./config");

  server = require("http").createServer(app);

  port = process.env.PORT || 3003;

  io = require("socket.io").listen(server);

  fs = require("fs");

  app.set("views", "./views/pages");

  app.set("view engine", "jade");

  app.use(express["static"](__dirname + "/public"));

  server.listen(port, function() {
    console.log("Server listening at port %d", port);
  });

  app.get("/", function(req, res) {
    console.log('request /');
    res.render("index", {
      title: "Happy Chess Game",
      socketurl: config.serverurl + ":" + port
    });
  });

}).call(this);
