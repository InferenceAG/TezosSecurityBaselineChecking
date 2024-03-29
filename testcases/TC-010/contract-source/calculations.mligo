type storage = nat
    
type value = nat

type parameter = 
| Add of value
| Sub of value

let add (store, param: storage * value) : operation list * storage =
    [], (store + param)

let sub (store, param: storage * value) : operation list * storage =
    match is_nat (store - param) with 
        | None -> failwith "substraction_below_zero"
        | Some res -> [], res

[@entry]
let main (action : parameter) (store : storage): operation list * storage =
    match action with
        | Add param -> add (store, param)        
        | Sub param -> sub (store, param)   