type storage = {
    admin: address; 
}

type parameter =
| Transfer of unit
| AdminTransfer of tez

// smart contract which initiates three transaction operations with increasing tez amount: 1tez, 2tez, 3tez
let transfer ( store, _param : storage * unit) : operation list * storage =
    let dest : unit contract = match (Tezos.get_contract_opt store.admin) with
        | None -> failwith "none" 
        | Some c -> c
        in

    let op1 : operation = Tezos.transaction unit 1tez dest in
    let op2 : operation = Tezos.transaction unit 2tez dest in 
    let op3 : operation = Tezos.transaction unit 3tez dest in
    [op1; op2; op3], store 

let adminTransfer(store, param: storage * tez) : operation list * storage =
    let () = assert(Tezos.get_sender() = store.admin) in
    
    let dest : unit contract = match (Tezos.get_contract_opt store.admin) with
        | None -> failwith "none" 
        | Some c  -> c
        in

    let op : operation = Tezos.transaction unit param dest in
    [op], store   

let main (action, store : parameter * storage) : operation list * storage =
    match action with
        | Transfer param        -> transfer (store, param)        
        | AdminTransfer param   -> adminTransfer (store, param) 