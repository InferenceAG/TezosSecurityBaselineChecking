    type storage is option (ticket (string));

    type parameter is
    | SetToken of option (ticket (string))
    | Init of address;

    function setToken(var _store : storage; const param: option (ticket (string))): (list(operation) * storage) is
    block {
        const txs : list(operation) = list[];   
    } with (txs, param)


    function init(const store : storage; const param: address): (list(operation) * storage) is
    block {

        
        const dest : contract(unit) = case (Tezos.get_contract_opt(param) : option(contract(unit))) of [ 
        | None -> failwith("none")
        | Some(x) -> x
        ];

        const op1 : operation = Tezos.transaction(unit, 0tez, dest);
        const txs : list(operation) = list[op1];   
    } with (txs, store)


    function main (const action : parameter; const store : storage): (list(operation) * storage) is
    block {
        skip
    } with case action of [
    | SetToken(param) -> setToken(store, param)        
    | Init(param) -> init(store, param) 
    ]
