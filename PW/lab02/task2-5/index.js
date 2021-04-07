const moment = require('moment');
const express = require('express');
 
const app = express();
 
app.get('/', (req, res) => {
    res.send(moment().format("YYYY-MM-DDThh:mm"));
});
 
app.listen(3000);
