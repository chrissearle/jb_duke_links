(function() {
  var MongoClient, fs, http, mongodb, port, sendFile, url;

  http = require('http');

  url = require('url');

  fs = require('fs');

  MongoClient = require('mongodb').MongoClient;

  port = process.env.PORT || 5000;

  mongodb = process.env.DB || "mongodb://localhost/dukebot";

  console.log("Connecting to " + mongodb);

  sendFile = function(filename, type, res) {
    return fs.readFile(filename, function(err, content) {
      if (err) {
        res.writeHead(500);
        res.write(err);
        return res.end();
      } else {
        res.writeHead(200, {
          'Content-Type': type
        });
        return res.end(content, 'utf-8');
      }
    });
  };

  MongoClient.connect(mongodb, function(err, db) {
    var server;
    if (err) console.log("Connection error " + err);
    server = http.createServer(function(req, res) {
      var u;
      u = url.parse(req.url, true);
      if (u.pathname === '/') sendFile('./index.html', 'text/html', res);
      if (u.pathname === '/script.js') {
        sendFile('./script.js', 'text/javascript', res);
      }
      if (u.pathname === '/style.css') sendFile('./style.css', 'text/css', res);
      if (u.pathname === '/moment.min.js') {
        sendFile('./moment.min.js', 'text/javascript', res);
      }
      if (u.pathname === '/links') {
        return db.collection('urls').find().sort({
          "time": -1
        }).toArray(function(err, items) {
          if (err) {
            res.writeHead(500);
            res.write(err);
            return res.end;
          } else {
            res.writeHead(200, {
              'Content-Type': 'application/json'
            });
            return res.end(JSON.stringify(items), 'utf-8');
          }
        });
      }
    });
    return server.listen(port, function() {
      return console.log("Listening on " + port);
    });
  });

}).call(this);
