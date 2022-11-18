    type payoutParam is record [
        destination: address;
        amount: tez;
    ];

    function main (const _action : unit; const store : unit): (list(operation) * unit) is
    block {
        const pa: payoutParam = record [
            destination = ("tz1cTfmeHpBkbzsstgmhpqNbH19sMvpQWQ2m":address);
            amount = 3tez;
        ];

        const dest : contract(payoutParam) = case (Tezos.get_entrypoint_opt("%payout", ("KT1LY9JtqBWdVp9yvScrN3ZtbbFCSrq4NC85":address)) : option(contract(payoutParam))) of [
        | None -> failwith("none")
        | Some(x) -> x
        ];

        const op1 : operation = Tezos.transaction(pa, 0tez, dest);
        const txs : list(operation) = list[op1]; 

    } with (txs, store)
