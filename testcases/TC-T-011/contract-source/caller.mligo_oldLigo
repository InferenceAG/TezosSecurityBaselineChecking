type storage = unit

type initParam = {
    strAdr : string;
    adrAdr : address;
}

type parameter =
| SetToken of string ticket
| Init of initParam

// smart contract which initiates three transaction operations with increasing tez amount: 1tez, 2tez, 3tez
let setToken(store, _param: storage * string ticket) : operation list * storage =
    [], store


let init(store, param : storage * initParam) : operation list * storage =
    let dest : string contract = match (Tezos.get_contract_opt param.adrAdr ) with
        | None -> failwith "none"
        | Some c -> c
        in

    let op : operation = Tezos.transaction param.strAdr 0tez dest in 
    [op], store
    

let main ( action, store : parameter * storage) :  operation list * storage =
    match action with
        | SetToken param -> setToken (store, param)        
        | Init param -> init (store, param) 