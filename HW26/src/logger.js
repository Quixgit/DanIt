const winston = require('winston');
const fluentLogger = require('fluent-logger');

// Настраиваем Fluentd транспорт
const fluentTransport = fluentLogger.createFluentSender('js_app', {
  host: 'fluentd',
  port: 24224,
  timeout: 3.0
});

// Добавляем обработку ошибок Fluent Logger
fluentTransport.on('error', (error) => {
  console.error('Fluent Logger Error:', error);
});

// Создаем Winston логгер
const logger = winston.createLogger({
  level: 'info', // Уровень логирования
  transports: [
    new winston.transports.Console(), // Логи в консоль
    new winston.transports.Stream({
      stream: {
        write: (message) => {
          // Отправка логов в Fluentd
          fluentTransport.emit('winston', {
            log: message.trim(), // Гарантируем наличие ключа `log`
            level: 'info',
            timestamp: new Date().toISOString()
          });
        }
      }
    })
  ]
});

// Экспортируем логгер
module.exports = logger;
