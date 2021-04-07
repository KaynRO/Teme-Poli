const func_async = async() => {
    await new Promise(resolve => setTimeout(resolve, 2000));
    return 1;
}


const func_promise = new Promise(resolve => setTimeout(resolve, 5000, 2));

const main = async () => {
    let ret = 0;
    ret = await func_async();
    console.log(ret);

    while(ret != 1){}
    func_promise.then((ret) => console.log(ret));
}

main();