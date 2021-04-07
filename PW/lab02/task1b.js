const mod = require('./task1a.js');

function vector_sum_odd(a, nr){
    return mod.vector_sum(a.filter(x => x % 2 == nr % 2))
}

module.exports = {
    vector_sum_odd
};