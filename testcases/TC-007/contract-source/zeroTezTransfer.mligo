type parameter =
| Transfer of address


let transfer (store, param: unit * address) : operation list * unit =
    let dest : unit contract = match Tezos.get_contract_opt(param) with    
        | None -> failwith "none"
        | Some c -> c
        in

    let op : operation = Tezos.transaction unit  0tez  dest in

    [op], store

let main (action, store : parameter * unit) : operation list * unit = 
    match action with 
        | Transfer param -> transfer (store, param)
