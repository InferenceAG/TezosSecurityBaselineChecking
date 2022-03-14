    type payoutParam is record
        destination: address;
        amount: tez;
    end;

    function main (const _action : unit; const store : unit): (list(operation) * unit) is
    block {
        const pa: payoutParam = record 
            destination = ("tz1PA7negGe2fBpPKAMSWii3mwh2Gt1LCffs":address);
            amount = 3tez;
        end;

        const dest : contract(payoutParam) = case (Tezos.get_entrypoint_opt("%payout", ("KT1TvfPtxKCZwDA3hEKFtSTVLJhqGEdE9tvE":address)) : option(contract(payoutParam))) of 
        | None -> failwith("none")
        | Some(x) -> x
        end;

        const op1 : operation = Tezos.transaction(pa, 0tez, dest);
        const txs : list(operation) = list[op1]; 

    } with (txs, store)
