let myArray = [];
let index = 0;

const insertIntoDb = (obj) => {
    const book = { id: index, ...obj };
    index++;
    myArray.push(book);
    return index - 1;
}

const getAllFromDb = () => { return myArray; }
const getFromDbById = (id) => {
    const obj = myArray.find(el => el.id === parseInt(id));
    if (obj) {
        return obj;
    }
    throw new Error(`The object with the id = ${id} does not exists!`);
}
const getFromDbByAuthor = (author) => {
    const books = myArray.filter(el => el.author === author);
    return books;
}
const updateById = (id, payload) => {
    const elemIndex = myArray.findIndex(el => el.id === parseInt(id));
    if (elemIndex > -1) {
        myArray[elemIndex] = {
            id,
            ...payload
        }
    } else {
        throw new Error(`The object with the id = ${id} does not exists!`);
    }
}
const removeFromDbById = (id) => {
    const newArray = myArray.filter(el => el.id !== parseInt(id));
    myArray = newArray;
}
const removeFromDbByAuthor = (author) => {
    const newArray = myArray.filter(el => el.author !== author);
    myArray = newArray;
}
const purgeDb = () => {
    myArray = [];
}
 
module.exports = {
    insertIntoDb,
    getAllFromDb,
    getFromDbById,
    getFromDbByAuthor,
    updateById,
    removeFromDbById,
    removeFromDbByAuthor,
    purgeDb
};