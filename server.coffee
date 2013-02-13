http = require('http')
url  = require('url')
fs   = require('fs')

MongoClient = require('mongodb').MongoClient

port = process.env.PORT || 5000
mongodb = process.env.DB || "mongodb://localhost/dukebot"

console.log("Connecting to " + mongodb)

sendFile = (filename, type, res) ->
  fs.readFile filename, (err, content) ->
    if err
      res.writeHead 500
      res.write err
      res.end()
    else
      res.writeHead 200, { 'Content-Type': type }
      res.end content, 'utf-8'

MongoClient.connect mongodb, (err, db) ->
  if err
    console.log "Connection error " + err
    
  server = http.createServer (req, res) ->
    u = url.parse(req.url, true)

    if u.pathname == '/'
      sendFile './index.html', 'text/html', res
          
    if u.pathname == '/script.js'
      sendFile './script.js', 'text/javascript', res
      
    if u.pathname == '/style.css'
      sendFile './style.css', 'text/css', res

    if u.pathname == '/moment.min.js'
      sendFile './moment.min.js', 'text/javascript', res

    if u.pathname == '/links'
      
      db.collection('urls').find().sort({"time":-1}).toArray (err, items) ->
        if err
          res.writeHead 500
          res.write err
          res.end
        else
          res.writeHead 200, { 'Content-Type': 'application/json' }
          res.end JSON.stringify(items), 'utf-8'

  server.listen port, ->
    console.log "Listening on " + port
