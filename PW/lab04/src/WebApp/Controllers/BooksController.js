const express = require('express');

const BooksRepository = require('../../Infrastructure/PostgreSQL/Repository/BooksRepository.js');
const ServerError = require('../Models/ServerError.js');
const { BookPostBody, BookPutBody } = require('../Models/Book.js');

const ResponseFilter = require('../Filters/ResponseFilter.js');

const Router = express.Router();

Router.post('/', async (req, res) => {
    
    const bookBody = new BookPostBody(req.body);

    const book = await BooksRepository.addAsync(bookBody.Name, bookBody.Author_ID);

    ResponseFilter.setResponseDetails(res, 201, book, req.originalUrl);
});

Router.get('/', async (req, res) => {

    const books = await BooksRepository.getAllAsync();

    ResponseFilter.setResponseDetails(res, 200, books);
});

Router.get('/:id', async (req, res) => {
    let {
        id
    } = req.params;

    id = parseInt(id);

    if (!id || id < 1) {
        throw new ServerError("Id should be a positive integer", 400);
    }
       
    const book = await BooksRepository.getByIdAsync(id);
    
    if (!book) {
        throw new ServerError(`Book with id ${id} does not exist!`, 404);
    }

    ResponseFilter.setResponseDetails(res, 200, book);
});

Router.put('/:id', async (req, res) => {

    const bookBody = new BookPutBody(req.body, req.params.id);

    const book = await BooksRepository.updateByIdAsync(bookBody.Id, bookBody.Name, bookBody.Author_ID);
        
    if (!book) {
        throw new ServerError(`Book with id ${id} does not exist!`, 404);
    }

    ResponseFilter.setResponseDetails(res, 200, book);
});

Router.delete('/:id', async (req, res) => {
    const {
        id
    } = req.params;

    if (!id || id < 1) {
        throw new ServerError("Id should be a positive integer", 400);
    }
    
    const book = await BooksRepository.deleteByIdAsync(parseInt(id));
    
    if (!book) {
        throw new ServerError(`Book with id ${id} does not exist!`, 404);
    }

    ResponseFilter.setResponseDetails(res, 204, "Entity deleted succesfully");
});

module.exports = Router;