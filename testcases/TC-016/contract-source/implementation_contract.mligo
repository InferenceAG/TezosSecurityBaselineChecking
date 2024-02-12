type parameter =
| Add of address
| AddMul of (nat * address)
| Call of address

type table_t = (nat, address) big_map

type storage = nat

[@entry]
let main (key, table: nat * table_t) (_store : storage) : operation list * storage = 
    let _result = match Big_map.find_opt key table with 
        | None -> failwith("test")
        | Some p -> p
    in
    
    ([] : operation list), key
    
