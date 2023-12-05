type storage = unit

type parameter =
| SetToken of string ticket
| Init of address

// smart contract which initiates three transaction operations with increasing tez amount: 1tez, 2tez, 3tez
let setToken(store, _param: storage * string ticket) : operation list * storage =
    [], store


let init(store, param : storage * address) : operation list * storage =
    let dest : unit contract = match (Tezos.get_contract_opt param ) with
        | None -> failwith "none"
        | Some c -> c
        in

    let op : operation = Tezos.transaction unit 0tez dest in 
    [op], store
    

let main ( action, store : parameter * storage) :  operation list * storage =
    match action with
        | SetToken param -> setToken (store, param)        
        | Init param -> init (store, param) 

