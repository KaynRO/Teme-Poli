const Router = require('express')();

const AuthorsController = require('./AuthorsController.js');

Router.use('/v1/authors', AuthorsController);

module.exports = Router;