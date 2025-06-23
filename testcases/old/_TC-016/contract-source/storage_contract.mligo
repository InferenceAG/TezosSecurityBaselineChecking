type parameter =
| Add of address
| AddMul of (nat * address)
| Call of (nat * address)

type table_t = (nat, address) big_map

type storage = {
    table : table_t;
    counter : nat;
}

let add (store, value: storage * address) : operation list * storage =
    let table_up = Big_map.update store.counter (Some(value)) store.table in
    let counter_up = store.counter + 1n in
    ([] : operation list), {store with counter=counter_up; table=table_up}

let addMul (store, (number, value): storage * (nat * address)) : operation list * storage =
    let rec loop (bigmap, counter, max : table_t * nat * nat) : (table_t * nat * nat) =
        if counter = max
            then
                (bigmap, counter, max)
            else
                let bigmap_up = Big_map.update counter (Some(value)) bigmap in
                let counter_up = counter + 1n in
                loop (bigmap_up, counter_up, max)
        in
    let (table_up, counter_up, _) = loop (store.table, store.counter, store.counter + number) in    
    ([] : operation list), {store with counter=counter_up; table=table_up}

let call (store, (key, dest): storage * (nat *address)) : operation list * storage =
    let dest_c : (nat * table_t) contract = match Tezos.get_contract_opt(dest) with    
        | None -> failwith "none"
        | Some c -> c
        in
    let op : operation = Tezos.transaction (key, store.table) 0tez dest_c in
    ([op] : operation list), store

[@entry]
let main (action : parameter) (store : storage) : operation list * storage = 
    match action with 
        | Add param -> add (store, param)
        | AddMul param -> addMul (store, param)
        | Call param -> call (store, param)
