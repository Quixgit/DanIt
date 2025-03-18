FROM node:18-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем исходный код приложения
COPY . .

# Открываем порт 10000
EXPOSE 10000

# Запускаем приложение
CMD ["npm", "start"]
