const express = require('express');
const db = require('./database.js');
const router = express.Router();


router.get('/', (req, res) => {
    res.setHeader("Content-Type", "application/json");
    res.status(200).send(db.getAllFromDb());
});


router.get('/:id', (req, res) => {
    res.setHeader("Content-Type", "application/json");
    try {
        res.status(200).send(db.getFromDbById(req.params.id));
    }
    catch {
        res.status(404).send();
    }
});


router.get('/', (req, res) => {
    res.setHeader("Content-Type", "application/json");
    const books = db.getFromDbByAuthor(req.query.author);

    if (books.length == 0)
        res.status(404).send();
    else
        res.status(200).send(books);
});


router.post('/', (req, res) => {
    const body = req.body;
    if (body["title"] && body["author"])
        if (Object.keys(body).length == 2)
            res.status(201).send(db.insertIntoDb(body).toString());
        else
            res.status(400).send("Body should only contain title and author fields");
    else
        res.status(400).send("Body does not contain title or author fields");


});


router.put('/:id', (req, res) => {
    const id = Number(req.params.id);
    const body = req.body;

    if (body["title"] && body["author"])
        if (Object.keys(body).length == 2)
            try {
                res.status(200).send(db.updateById(id, body));
            }
            catch (e) {
                console.log(e);
                res.status(404).send();
            }
        else
            res.status(400).send("Body should only contain title and author fields");
    else
        res.status(400).send("Body does not contain title or author fields");


});


router.delete('/', (req, res) => {
    if (Object.keys(req.query).length == 0)
        db.purgeDb();
    else
        db.removeFromDbByAuthor(req.query.author);
    res.status(200).send();
});


router.delete('/:id', (req, res) => {
    db.removeFromDbById(req.params.id);
    res.status(200).send();
});

 
module.exports = router;