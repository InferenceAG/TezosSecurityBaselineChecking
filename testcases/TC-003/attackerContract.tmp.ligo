    type payoutParam is record
        destination: address;
        amount: tez;
    end;

    function main (const _action : unit; const store : unit): (list(operation) * unit) is
    block {
        const pa: payoutParam = record 
            destination = ("tz1cTfmeHpBkbzsstgmhpqNbH19sMvpQWQ2m":address);
            amount = 3tez;
        end;

        const dest : contract(payoutParam) = case (Tezos.get_entrypoint_opt("%payout", ("KT1Q1D728SJ8oBodUH6qPfjcAgtuRdTBch6p":address)) : option(contract(payoutParam))) of 
        | None -> failwith("none")
        | Some(x) -> x
        end;

        const op1 : operation = Tezos.transaction(pa, 0tez, dest);
        const txs : list(operation) = list[op1]; 

    } with (txs, store)
