const http = require('http');
const hostname = '0.0.0.0';
const port = process.env.PORT || 8080;
const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('ok');
    return;
  } else {
    res.writeHead(200, {'Content-Type': 'text/plain'});
    res.end('Hello from Node.js app\n');
    return;
  }
});
server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});