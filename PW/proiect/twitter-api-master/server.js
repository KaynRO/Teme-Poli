const mongoose = require('mongoose');
const dotenv = require('dotenv').config({ path: './config.env' });
const colors = require('colors');
const DBConnect = require('./utils/dbConnect');

process.on('uncaughtException', (error) => {
    console.log(' uncaught Exception => shutting down..... ');
    console.log(error.name, error.message);
    process.exit(1);
});

const app = require('./app');
// database connection
DBConnect();

// server
const port = process.env.PORT || 8000;
const server = app.listen(port, () => {
  console.log(`App is running on port ${port}`.yellow.bold);
});


process.on('unhandledRejection', (error) => {
  console.log(' Unhandled Rejection => shutting down..... ');
  console.log(error.name, error.message);
  server.close(() => {
    process.exit(1);
  });

});
