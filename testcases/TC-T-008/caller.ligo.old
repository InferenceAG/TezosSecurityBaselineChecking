    type storage is unit;

    type parameter is
    | SetToken of ticket (string)
    | Init of address;

    // smart contract which initiates three transaction operations with increasing tez amount: 1tez, 2tez, 3tez
    function setToken(var store : storage; const _param: ticket (string)): (list(operation) * storage) is
    block {
        
        const txs : list(operation) = list[];   
    } with (txs, store)


    function init(const store : storage; const param: address): (list(operation) * storage) is
    block {

        const dest : contract(unit) = case (Tezos.get_contract_opt(param) : option(contract(unit))) of 
        | None -> failwith("none")
        | Some(x) -> x
        end;

        const op1 : operation = Tezos.transaction(unit, 0tez, dest);
        const txs : list(operation) = list[op1];   
    } with (txs, store)


    function main (const action : parameter; const store : storage): (list(operation) * storage) is
    block {
        skip
    } with case action of
    | SetToken(param) -> setToken(store, param)        
    | Init(param) -> init(store, param) 
    end;
