    type storage is nat;
     
    type value is nat;

    type parameter is
    | Add of value
    | Sub of value;


    function add(const store : storage; const param: value): (list(operation) * storage) is ((nil : list (operation)), store + param)
    function sub(const store : storage; const param: value): (list(operation) * storage) is 
    block {
        const result: nat = case is_nat(store - param) of [
        | None -> failwith("substraction_below_zero")
        | Some(v) -> v
        ];

    }
    with ((nil : list (operation)), result)

    function main (const action : parameter; const store : storage): (list(operation) * storage) is
    block {
        skip
    } with case action of [
    | Add(param) -> add(store, param)        
    | Sub(param) -> sub(store, param)
    ];
    