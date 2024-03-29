type storage = {
    admin: address; 
}

type result = operation list * storage

// smart contract which initiates three transaction operations with increasing tez amount: 1tez, 2tez, 3tez
[@entry] let transfer (_param : unit) (store : storage) : result =
    let dest : unit contract = match (Tezos.get_contract_opt store.admin) with
        | None -> failwith "none" 
        | Some c -> c
        in

    let op1 : operation = Tezos.transaction unit 1tez dest in
    let op2 : operation = Tezos.transaction unit 2tez dest in 
    let op3 : operation = Tezos.transaction unit 3tez dest in
    [op1; op2; op3], store 

[@entry] let adminTransfer (param : tez) (store : storage) : result =
    let () = assert(Tezos.get_sender() = store.admin) in
    
    let dest : unit contract = match (Tezos.get_contract_opt store.admin) with
        | None -> failwith "none" 
        | Some c  -> c
        in

    let op : operation = Tezos.transaction unit param dest in
    [op], store   
