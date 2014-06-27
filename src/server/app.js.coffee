express = require("express")
app = express()
config = require("./config")
server = require("http").createServer(app)
port = process.env.PORT or 3003
io = require("socket.io").listen(server)
fs = require("fs")
app.set "views", "./views/pages"
app.set "view engine", "jade"
app.use express.static(__dirname + "/public")
server.listen port, ->
  console.log "Server listening at port %d", port
  return

app.get "/", (req, res) ->
  console.log('request /')
  res.render "index",
    title: "Happy Chess Game"
    socketurl: config.serverurl + ":" + port

  return