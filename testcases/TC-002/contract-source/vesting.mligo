type storage = {
    admin          : address;
    minLockedValue : tez;
}

type payoutParam = {
    destination    : address;
    amount         : tez;
}

type parameter =
    | Payout of payoutParam
    | AdminPayout of payoutParam

// smart contract "should" ensure that always "minLockedValue" is available as tez balance in the smart contract
let payout (store, param : storage * payoutParam) : operation list * storage =
    let residualAmount : tez = match (Tezos.get_balance() - param.amount) with 
        | None -> failwith "negative balance"
        | Some amt -> amt
        in

    let () = assert_with_error (residualAmount >= store.minLockedValue) "Assert failure - Min locked value not ensured." in
    
    let dest : unit contract = match Tezos.get_contract_opt(param.destination) with
        | None -> failwith "none"
        | Some c -> c
        in

    let op : operation = Tezos.transaction unit param.amount dest in
    [op], store

let adminPayout (store, param : storage * payoutParam) :  operation list * storage =
    let () = assert (Tezos.get_sender() = store.admin) in
    
    let dest : unit contract = match (Tezos.get_contract_opt(param.destination)) with 
        | None -> failwith "none" 
        | Some c -> c
        in
    
    let op : operation = Tezos.transaction unit  param.amount  dest  in 
    [op], store

let main (action, store : parameter * storage) : operation list * storage =
    match action with
        | Payout param          -> payout (store, param)
        | AdminPayout param     -> adminPayout (store, param)