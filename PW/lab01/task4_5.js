const apply_func = (vt, index, f) => {
    f(vt[index]);
}

let vt = Array.from(Array(100).keys());

console.log(vt.filter(i => i % 2 == 0));

apply_func(vt, 3, console.log);