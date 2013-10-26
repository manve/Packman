var http = require('http');
var fs = require('fs');

var server = http.createServer(function (req, res) {
  
  console.log(req.url);
    fs.readFile(__dirname + req.url, function(err, data){
      console.log('error: ' + err);
      if (err){
        throw err;
      }

      console.log('file: ' + req.url + ' loading..');
     
      switch(req.url){
        case "/img/game-over-black-wallpaper.jpg" :
          res.writeHead(200, {
          'Content-Length': 151781,
          'Content-Type': 'image/jpg'});

          res.end(data);
          break;
        case "/map.txt":
          res.writeHead(200, {
            'Content-Length': 2729,
            'Content-Type': 'text/plain' });
 
          res.end(data, 'utf8');

          break;
        default:{         
          res.writeHead(200, { 'Content-Length': 0 });
          res.end();
        }
      }
    });
});

server.listen(1444);
console.log('server started on 1447 port');