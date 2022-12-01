    type transferParam is record [
        contractAddress: address;
        payoutAmount: tez;
    ]


    function main (const _action : unit; const store : nat): (list(operation) * nat) is
    block {
        var txs : list(operation) := list[];

        if Tezos.get_level() =/= store then {
            const pa: transferParam = record [
                contractAddress = Tezos.get_self_address();
                payoutAmount = 3tez;
            ];

            const dest : contract(transferParam) = case (Tezos.get_entrypoint_opt("%transfer", ("VARcontract":address)) : option(contract(transferParam))) of [
            | None -> failwith("none")
            | Some(x) -> x
            ];

            const op1 : operation = Tezos.transaction(pa, 0tez, dest);
            txs := list[op1]; 
        }

    } with (txs, Tezos.get_level())
