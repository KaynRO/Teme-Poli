const ServerError = require('./ServerError.js');

class BookPostBody {
    constructor (body) {
        this.name = body.name;
        this.author_id = body.authori_id;

        if (this.name == null || this.firstName.length < 4) {
            throw new ServerError("Name is missing", 400);
        }
    
        if (this.author_id == null || isNaN(this.author_id)) {
            throw new ServerError("Book ID is missing or is not a number", 400);
        }
    }

    get Name () {
        return this.name;
    }

    get BookID () {
        return this.author_id;
    }
}

class BookPutBody extends BookPostBody {
    constructor (body, id) {
        super(body);
        this.id = parseInt(id);

        if (!this.id || this.id < 1) {
            throw new ServerError("Id should be a positive integer", 400);
        }
    }

    get Id () {
        return this.id;
    }
}

module.exports =  {
    BookPostBody,
    BookPutBody
}