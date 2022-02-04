    type parameter is
    | Transfer of address;

    function transfer(const store : unit; const param: address): (list(operation) * unit) is
    block {
           
        const dest : contract(unit) = case (Tezos.get_contract_opt(param) : option(contract(unit))) of 
        | None -> failwith("none")
        | Some(x) -> x
        end;

        const op1 : operation = Tezos.transaction(unit, 0tez, dest);
        const txs : list(operation) = list[op1];   
    } with (txs, store)


  
    function main (const action : parameter; const store : unit): (list(operation) * unit) is
    block {
        skip
    } with case action of
    | Transfer(param) -> transfer(store, param)        
    end;
