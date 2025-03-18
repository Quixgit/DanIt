const express = require('express');
const logger = require('./logger');

const app = express();
const PORT = process.env.PORT || 10000;

// Логируем каждый запрос через middleware
app.use((req, res, next) => {
  logger.info(`Incoming request: ${req.method} ${req.url}`, {
    path: req.path,
    method: req.method,
    headers: req.headers
  });
  next();
});

// Маршрут "/"
app.get('/', (req, res) => {
  logger.info('Home route accessed', { path: req.path });
  res.send('Home route accessed, Hello from NodeJS!');
});

// Маршрут для ошибок "/error"
app.get('/error', (req, res) => {
  logger.error('An error occurred with NodeJS!', { path: req.path });
  res.status(500).send('An error occurred!');
});

// Запуск сервера
app.listen(PORT, '0.0.0.0', () => {
  logger.info(`Server is running on port ${PORT}`);
});
