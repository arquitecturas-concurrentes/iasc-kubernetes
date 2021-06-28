'use strict';

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';
var healthCounter = 0;
const threshold = 3;


// App
const app = express();
app.get('/', (req, res) => {
  res.send('<p>Estoy vivo, vivooooo!</p>');
});

app.get('/health', (req, res) => {
  healthCounter++;
  if (healthCounter > threshold) {
    res.status(500);
    res.send('Hay prolemas. Reiuniciar el servicio.');
    return;
  }
  
  res.status(200)
  res.send('Ok');
});


app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);