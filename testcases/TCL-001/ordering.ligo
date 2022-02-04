    type storage is record
        admin: address; 
    end;

    type parameter is
    | Transfer of unit
    | AdminTransfer of tez;

    // smart contract which initiates three transaction operations with increasing tez amount: 1tez, 2tez, 3tez
    function transfer(const store : storage; const _param: unit): (list(operation) * storage) is
    block {
           
        const dest : contract(unit) = case (Tezos.get_contract_opt(store.admin) : option(contract(unit))) of 
        | None -> failwith("none")
        | Some(x) -> x
        end;

        const op1 : operation = Tezos.transaction(unit, 1tez, dest);
        const op2 : operation = Tezos.transaction(unit, 2tez, dest);
        const op3 : operation = Tezos.transaction(unit, 3tez, dest);
        const txs : list(operation) = list[op1; op2; op3];   
    } with (txs, store)


    function adminTransfer(const store : storage; const param: tez): (list(operation) * storage) is
    block {

        assert(Tezos.sender = store.admin);
        
        const dest : contract(unit) = case (Tezos.get_contract_opt(store.admin) : option(contract(unit))) of 
        | None -> failwith("none")
        | Some(x) -> x
        end;

        const op1 : operation = Tezos.transaction(unit, param, dest);
        const txs : list(operation) = list[op1];   
    } with (txs, store)


    function main (const action : parameter; const store : storage): (list(operation) * storage) is
    block {
        skip
    } with case action of
    | Transfer(param) -> transfer(store, param)        
    | AdminTransfer(param) -> adminTransfer(store, param) 
    end;