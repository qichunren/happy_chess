bodyParser = require('body-parser')
cookieParser = require('cookie-parser')
express = require("express")
app = express()
router = express.Router()
config = require("./config")
server = require("http").createServer(app)
port = process.env.PORT or 3003
io = require("socket.io").listen(server)
fs = require("fs")
app.set "views", "./views/pages"
app.set "view engine", "jade"
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: true)
app.use cookieParser('qichunren')
app.use express.static(__dirname + "/public")

router.get "/", (req, res) ->
  console.log "cookies user:", req.cookies
  if req.cookies.user
    res.render "index",
      title: "Happy Chess Game"
      username: req.cookies.user
      socketurl: config.serverurl + ":" + port
  else
    res.redirect('/signin')
  return

router.get "/signin", (req, res) ->
  res.render "signin"
  return

router.post "/signin", (req, res) ->
  #req.cookies.user = req.param('username')
  res.cookie('user', req.param('username'))
  console.log "req.param('username')", req.param('username')
  console.log req.body
  res.redirect('/')
  return

app.use('/', router)

server.listen port, ->
  console.log "Server listening at port %d", port
  return