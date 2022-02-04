    type storage is record
        atStart: tez;
        atEnd: tez;
    end;

    type parameter is
    | Transfer of option (address);

    function transfer(var store : storage; const param: option (address)): (list(operation) * storage) is
    block {
        store.atStart := Tezos.balance;

        const txs: list(operation) = case param of 
        | None -> nil
        | Some(x) -> block {
            const dest : contract(option(address)) = case (Tezos.get_contract_opt(x) : option(contract(option(address)))) of 
            | None -> failwith("none")
            | Some(x) -> x
            end;

            const op1 : operation = Tezos.transaction((None: option(address)), 5mutez, dest);
            const lop : list(operation) = list[op1]; 
        } with lop
        end; 
        
        store.atEnd := Tezos.balance;
        
    } with (txs, store)
  
    function main (const action : parameter; const store : storage): (list(operation) * storage) is
    block {
        skip
    } with case action of
    | Transfer(param) -> transfer(store, param)        
    end;