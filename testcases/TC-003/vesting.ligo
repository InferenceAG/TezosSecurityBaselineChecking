    type storage is record
        admin: address;
        minLockedValue: tez;  
        balance: tez;
    end;

    type payoutParam is record
        destination: address;
        amount: tez;
    end;

    type parameter is
    | Payout of payoutParam
    | AdminPayout of payoutParam;


    // smart contract "should" ensure that always "minLockedValue" is available as tez balance in the smart contract
    function payout(var store : storage; const param: payoutParam): (list(operation) * storage) is
    block {
        store.balance := store.balance + Tezos.amount;
        assert(store.balance - param.amount >= store.minLockedValue);
        
        const dest : contract(unit) = case (Tezos.get_contract_opt(param.destination) : option(contract(unit))) of 
        | None -> failwith("none")
        | Some(x) -> x
        end;

        store.balance := store.balance - param.amount;

        const op1 : operation = Tezos.transaction(unit, param.amount, dest);
        const txs : list(operation) = list[op1];   
    } with (txs, store)


    function adminPayout(var store : storage; const param: payoutParam): (list(operation) * storage) is
    block {
        store.balance := store.balance + Tezos.amount;
        assert(Tezos.sender = store.admin);
        
        const dest : contract(unit) = case (Tezos.get_contract_opt(param.destination) : option(contract(unit))) of 
        | None -> failwith("none")
        | Some(x) -> x
        end;

        store.balance := store.balance - param.amount;

        const op1 : operation = Tezos.transaction(unit, param.amount, dest);
        const txs : list(operation) = list[op1];   
    } with (txs, store)


    function main (const action : parameter; const store : storage): (list(operation) * storage) is
    block {
        skip
    } with case action of
    | Payout(param) -> payout(store, param)        
    | AdminPayout(param) -> adminPayout(store, param) 
    end;