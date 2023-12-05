type storage = unit

type parameter =
| Call of address


let call ( store, param : storage * address) : operation list * storage =
    let dest : unit contract = match (Tezos.get_contract_opt param) with
        | None -> failwith "none" 
        | Some c -> c
        in
    let op : operation = Tezos.transaction unit 0tez dest in
    [op], store 

[@entry]
let main (action : parameter) (store : storage) : operation list * storage =
    match action with
        | Call param   -> call (store, param)        
