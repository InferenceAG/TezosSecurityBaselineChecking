type storage = nat
    
type addParamNoAnnot = (nat, "", nat, "") michelson_pair

type input = 
| Add of unit
| AddNoAnnot of unit
| AddWrongAnnot of unit

type addParamWrong = {
    a: nat;
    b: nat;
}

type addParam = {
    valueA: nat;
    valueB: nat;
}

type inputcallA = {
    entrypoint: input;
    param: addParam;
}

type inputcallB = {
    entrypoint: input;
    param: addParamNoAnnot;
}

type inputcallC = {
    entrypoint: input;
    param: addParamWrong;
}

type parameter =
| Add               of addParam
| AddNoAnnot        of addParamNoAnnot
| AddWrongAnnot     of addParamWrong
| Call              of inputcallA
| CallNoAnnot       of inputcallB
| CallWrongAnnot    of inputcallC


let add (_store,  param: storage * addParam) : operation list * storage =
    [], (param.valueA + param.valueB)

let addNoAnnot (_store, param: storage * addParamNoAnnot) : operation list * storage =
    [], (param.0 + param.1)

let addWrongAnnot ( _store, param: storage * addParamWrong) : operation list * storage =
    [], (param.a + param.b)

let call ( store, param: storage * inputcallA) : operation list * storage =

    match param.entrypoint with
        | Add -> 
            let dest : addParam contract = match (Tezos.get_entrypoint_opt "%add" (Tezos.get_self_address ())) with
                | None -> failwith("none")
                | Some(x) -> x
                in
            let op : operation = Tezos.transaction param.param 0mutez dest in
            [op], store
        | AddNoAnnot ->
            let dest : addParam contract = match (Tezos.get_entrypoint_opt "%addNoAnnot" (Tezos.get_self_address ())) with
                | None -> failwith("none")
                | Some(x) -> x
                in
            let op : operation = Tezos.transaction param.param 0mutez dest in
            [op], store
        | AddWrongAnnot ->
            let dest : addParam contract = match (Tezos.get_entrypoint_opt "%addWrongAnnot" (Tezos.get_self_address ())) with
                | None -> failwith("none")
                | Some(x) -> x
                in
            let op : operation = Tezos.transaction param.param 0mutez dest in
            [op], store

let callNoAnnot (store, param: storage * inputcallB) : operation list * storage =
    match param.entrypoint with
        | Add -> 
            let dest : addParamNoAnnot contract = match (Tezos.get_entrypoint_opt "%add" (Tezos.get_self_address ())) with
                | None -> failwith("none")
                | Some(x) -> x
                in
            let op : operation = Tezos.transaction param.param 0mutez dest in
            [op], store
        | AddNoAnnot ->
            let dest : addParamNoAnnot contract = match (Tezos.get_entrypoint_opt "%addNoAnnot" (Tezos.get_self_address ())) with
                | None -> failwith("none")
                | Some(x) -> x
                in
            let op : operation = Tezos.transaction param.param 0mutez dest in
            [op], store
        | AddWrongAnnot ->
            let dest : addParamNoAnnot contract = match (Tezos.get_entrypoint_opt "%addWrongAnnot" (Tezos.get_self_address ())) with
                | None -> failwith("none")
                | Some(x) -> x
                in
            let op : operation = Tezos.transaction param.param 0mutez dest in
            [op], store

let callWrongAnnot(store, param: storage * inputcallC) : operation list * storage = 
    match param.entrypoint with
        | Add -> 
            let dest : addParamWrong contract = match (Tezos.get_entrypoint_opt "%add" (Tezos.get_self_address ())) with
                | None -> failwith("none")
                | Some(x) -> x
                in
            let op : operation = Tezos.transaction param.param 0mutez dest in
            [op], store
        | AddNoAnnot ->
            let dest : addParamWrong contract = match (Tezos.get_entrypoint_opt "%addNoAnnot" (Tezos.get_self_address ())) with
                | None -> failwith("none")
                | Some(x) -> x
                in
            let op : operation = Tezos.transaction param.param 0mutez dest in
            [op], store
        | AddWrongAnnot ->
            let dest : addParamWrong contract = match (Tezos.get_entrypoint_opt "%addWrongAnnot" (Tezos.get_self_address ())) with
                | None -> failwith("none")
                | Some(x) -> x
                in
            let op : operation = Tezos.transaction param.param 0mutez dest in
            [op], store

let main (action, store : parameter * storage) : operation list * storage =
    match action with
        | Add param             -> add (store, param)        
        | AddNoAnnot param      -> addNoAnnot (store, param)    
        | AddWrongAnnot param   -> addWrongAnnot (store, param)    
        | Call param            -> call (store, param) 
        | CallNoAnnot param     -> callNoAnnot (store, param) 
        | CallWrongAnnot param  -> callWrongAnnot (store, param) 
