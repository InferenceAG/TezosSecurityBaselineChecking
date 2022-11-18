    type storage is nat;
       
    type addParamNoAnnot is michelson_pair(nat, "", nat, "")
 
    type addParamWrong is record [
        a: nat;
        b: nat;
    ];
   
    type addParam is record [
        valueA: nat;
        valueB: nat;
    ];

    type inputcallA is record [
        entrypoint: string;
        param: addParam;
    ];

    type inputcallB is record [
        entrypoint: string;
        param: addParamNoAnnot;
    ];

    type inputcallC is record [
        entrypoint: string;
        param: addParamWrong;
    ];

    type parameter is
    | Add of addParam
    | AddNoAnnot of addParamNoAnnot
    | AddWrongAnnot of addParamWrong
    | Call of inputcallA
    | CallNoAnnot of inputcallB
    | CallWrongAnnot of inputcallC;


    function add(const _store : storage; const param: addParam): (list(operation) * storage) is ((nil : list (operation)), param.valueA + param.valueB)
    function addNoAnnot(const _store : storage; const param: addParamNoAnnot): (list(operation) * storage) is ((nil : list (operation)), param.0 + param.1)
    function addWrongAnnot(const _store : storage; const param: addParamWrong): (list(operation) * storage) is ((nil : list (operation)), param.a + param.b)

    function call(const store : storage; const param: inputcallA): (list(operation) * storage) is
    block {
        var txs : list(operation) := list[];  

        if param.entrypoint = "Add" then {
            const dest : contract(addParam) = case (Tezos.get_entrypoint_opt("%add", Tezos.get_self_address()) : option(contract(addParam))) of [
            | None -> failwith("none")
            | Some(x) -> x
            ];
            const op1 : operation = Tezos.transaction(param.param, 0mutez, dest);
            txs := op1 # txs;
        }
        else skip;
        
        if param.entrypoint = "AddNoAnnot" then {
            const dest : contract(addParam) = case (Tezos.get_entrypoint_opt("%addNoAnnot", Tezos.get_self_address()) : option(contract(addParam))) of [
            | None -> failwith("none")
            | Some(x) -> x
            ];
            const op1 : operation = Tezos.transaction(param.param, 0mutez, dest);
            txs := op1 # txs;
        }
        else skip;
        
        if param.entrypoint = "AddWrongAnnot" then {
            const dest : contract(addParam) = case (Tezos.get_entrypoint_opt("%addWrongAnnot", Tezos.get_self_address()) : option(contract(addParam))) of [
            | None -> failwith("none")
            | Some(x) -> x
            ];
            const op1 : operation = Tezos.transaction(param.param, 0mutez, dest);
            txs := op1 # txs;
        }
        else skip;

    } with (txs, store)

    function callNoAnnot(const store : storage; const param: inputcallB): (list(operation) * storage) is
    block {
        var txs : list(operation) := list[];  
        if param.entrypoint = "Add" then {
            const dest : contract(addParamNoAnnot) = case (Tezos.get_entrypoint_opt("%add", Tezos.get_self_address()) : option(contract(addParamNoAnnot))) of [
            | None -> failwith("none")
            | Some(x) -> x
            ];
            const op1 : operation = Tezos.transaction(param.param, 0mutez, dest);
            txs := op1 # txs;
        }
        else skip;
        
        if param.entrypoint = "AddNoAnnot" then {
            const dest : contract(addParamNoAnnot) = case (Tezos.get_entrypoint_opt("%addNoAnnot", Tezos.get_self_address()) : option(contract(addParamNoAnnot))) of [
            | None -> failwith("none")
            | Some(x) -> x
            ];
            const op1 : operation = Tezos.transaction(param.param, 0mutez, dest);
            txs := op1 # txs;
        }
        else skip;
        
        if param.entrypoint = "AddWrongAnnot" then {
            const dest : contract(addParamNoAnnot) = case (Tezos.get_entrypoint_opt("%addWrongAnnot", Tezos.get_self_address()) : option(contract(addParamNoAnnot))) of [
            | None -> failwith("none")
            | Some(x) -> x
            ];
            const op1 : operation = Tezos.transaction(param.param, 0mutez, dest);
            txs := op1 # txs;
        }
        else skip;

    } with (txs, store)

    function callWrongAnnot(const store : storage; const param: inputcallC): (list(operation) * storage) is
    block {
        var txs : list(operation) := list[];  
        if param.entrypoint = "Add" then {
            const dest : contract(addParamWrong) = case (Tezos.get_entrypoint_opt("%add", Tezos.get_self_address()) : option(contract(addParamWrong))) of [
            | None -> failwith("none")
            | Some(x) -> x
            ];
            const op1 : operation = Tezos.transaction(param.param, 0mutez, dest);
            txs := op1 # txs;
        }
        else skip;
        
        if param.entrypoint = "AddNoAnnot" then {
            const dest : contract(addParamWrong) = case (Tezos.get_entrypoint_opt("%addNoAnnot", Tezos.get_self_address()) : option(contract(addParamWrong))) of [
            | None -> failwith("none")
            | Some(x) -> x
            ];
            const op1 : operation = Tezos.transaction(param.param, 0mutez, dest);
            txs := op1 # txs;
        }
        else skip;
        
        if param.entrypoint = "AddWrongAnnot" then {
            const dest : contract(addParamWrong) = case (Tezos.get_entrypoint_opt("%addWrongAnnot", Tezos.get_self_address()) : option(contract(addParamWrong))) of [ 
            | None -> failwith("none")
            | Some(x) -> x
            ];
            const op1 : operation = Tezos.transaction(param.param, 0mutez, dest);
            txs := op1 # txs;
        }
        else skip;

    } with (txs, store)

    function main (const action : parameter; const store : storage): (list(operation) * storage) is
    block {
        skip
    } with case action of [
    | Add(param) -> add(store, param)        
    | AddNoAnnot(param) -> addNoAnnot(store, param)    
    | AddWrongAnnot(param) -> addWrongAnnot(store, param)    
    | Call(param) -> call(store, param) 
    | CallNoAnnot(param) -> callNoAnnot(store, param) 
    | CallWrongAnnot(param) -> callWrongAnnot(store, param) 
    ];