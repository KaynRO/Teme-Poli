function vector_sum(a){
    return a.reduce((a, b) => a + b, 0)
}

module.exports = {
    vector_sum
};