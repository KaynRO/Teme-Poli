const express = require('express');
const menuRouter = require('./route.js');
const app = express();

app.use(express.json());
app.use(express.raw());
app.use(express.urlencoded({ extended: true }));
app.use('/menus', menuRouter);

app.listen(3000, () => console.log('App is listening on port 3000'));