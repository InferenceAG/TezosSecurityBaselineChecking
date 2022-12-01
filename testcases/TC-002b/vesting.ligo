    type storage is record [
        admin: address;
        minLockedValue: tez;  
    ]

    type transferParam is record [
        contractAddress: address;
        payoutAmount: tez;
    ]

    type payoutParam is record [
        destination: address;
        amount: tez;
    ]

    type parameter is
    | Transfer of transferParam
    | AdminPayout of payoutParam;

    // smart contract "should" ensure that always "minLockedValue" is available as tez balance in the smart contract
    function transfer(const store : storage; const param: transferParam): (list(operation) * storage) is
    block {
        const residualAmount: tez = case ((Tezos.get_balance() - param.payoutAmount): option(tez)) of [
            | None -> failwith("negative balance")
            | Some(x) -> x
        ];
        assert(residualAmount >= store.minLockedValue);

        const contract: contract(unit) = case (Tezos.get_contract_opt(param.contractAddress) : option(contract(unit))) of [ 
        | None -> failwith("none")
        | Some(x) -> x
        ];

        const contractCall : operation = Tezos.transaction(unit, 0mutez , contract);
        
        const dest : contract(unit) = case (Tezos.get_contract_opt(Tezos.get_sender()) : option(contract(unit))) of [ 
        | None -> failwith("none")
        | Some(x) -> x
        ];

        const tezTransfer : operation = Tezos.transaction(unit, param.payoutAmount, dest);
        const txs : list(operation) = list[contractCall; tezTransfer];   
    } with (txs, store)


    function adminPayout(const store : storage; const param: payoutParam): (list(operation) * storage) is
    block {

        assert(Tezos.get_sender() = store.admin);
        
        const dest : contract(unit) = case (Tezos.get_contract_opt(param.destination) : option(contract(unit))) of [
        | None -> failwith("none")
        | Some(x) -> x
        ];

        const op1 : operation = Tezos.transaction(unit, param.amount, dest);
        const txs : list(operation) = list[op1];   
    } with (txs, store)


    function main (const action : parameter; const store : storage): (list(operation) * storage) is
    block {
        skip
    } with case action of [
    | Transfer(param) -> transfer(store, param)        
    | AdminPayout(param) -> adminPayout(store, param) 
    ]