express = require('express')
connectassets = require('connect-assets')

MongoClient = require('mongodb').MongoClient

port = process.env.PORT || 5000
mongodb = process.env.DB || "mongodb://localhost/dukebot"

app = express()

# Configuration

app.configure ->
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.set('view options', {layout: false})
  
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + '/public')
  app.use connectassets()
  
app.configure 'development', ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', ->
  app.use express.errorHandler()

# Routes

MongoClient.connect mongodb, (err, db) ->
  if err
    console.log "Connection error " + err
    
  app.get '/', (req, res) ->
    res.render('index', { title: 'DukeBot Links' })

  app.get '/links.json', (req, res) ->
    db.collection('urls').find().sort({"time":-1}).toArray (err, items) ->
      if err
        res.writeHead 500
        res.write err
        res.end
      else
        res.writeHead 200, { 'Content-Type': 'application/json' }
        res.end JSON.stringify(items), 'utf-8'

  app.listen port, ->
    console.log("express-bootstrap app running")
