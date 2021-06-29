'use strict';

const express = require('express');

//fibonacci
function fibonacci(n) {
  return n < 1 ? 0
       : n <= 2 ? 1
       : fibonacci(n - 1) + fibonacci(n - 2);
}


// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
  res.send('<p>Estoy vivo, vivooooo!</p>');
});

app.get('/fib', (req, res) => {
  console.log(`Recibiendo request de ${req}`);
  res.send(`El fibonacci de 40 es: ${fibonacci(40)}`);
});

app.get('/health', (req, res) => {
  res.status(200)
  res.send('Ok');
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);