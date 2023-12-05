type storage = {
    atStart: tez;
    atEnd: tez;
}

type parameter =
| Transfer of address option

let transfer (store, param: storage * address option) : operation list * storage =
    let store = { store with atStart = Tezos.get_balance()} in

    match param with 
        | None -> ([], {store with atEnd = Tezos.get_balance()})
        | Some addr -> 
            (match (Tezos.get_contract_opt(addr) : ((address option) contract) option) with
                | None -> failwith "none"
                | Some dest -> 
                    let op : operation = Tezos.transaction (None : address option) 5mutez dest in 
                    [op], {store with atEnd = Tezos.get_balance()}
            )
            
let main (action, store : parameter * storage): operation list * storage = 
    match action with 
        | Transfer param  -> transfer (store, param)        