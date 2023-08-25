    type storage is unit;

    type initParam is record [
        strAdr : string;
        adrAdr : address;
    ];

    type parameter is
    | SetToken of option(ticket (string))
    | Init of initParam;

    // smart contract which initiates three transaction operations with increasing tez amount: 1tez, 2tez, 3tez
    function setToken(var store : storage; const _param: option (ticket (string))): (list(operation) * storage) is
    block {
        const txs : list(operation) = list[];   
    } with (txs, store)


    function init(const store : storage; const param: initParam): (list(operation) * storage) is
    block {

        
        const dest : contract(string) = case (Tezos.get_contract_opt(param.adrAdr) : option(contract(string))) of [
        | None -> failwith("none")
        | Some(x) -> x
        ];

        const op1 : operation = Tezos.transaction(param.strAdr, 0tez, dest);
        const txs : list(operation) = list[op1];   
    } with (txs, store)


    function main (const action : parameter; const store : storage): (list(operation) * storage) is
    block {
        skip
    } with case action of [
    | SetToken(param) -> setToken(store, param)        
    | Init(param) -> init(store, param) 
    ];
