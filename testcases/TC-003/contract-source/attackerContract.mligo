type payoutParam = {
    destination: address;
    amount: tez;
}

type storage = {
    dest_address : address;
    dest_contract : address;
}

let main (_action , store : unit * storage) : operation list * storage =
    let pa : payoutParam = {
        destination = store.dest_address;
        amount = 3tez;
    } in

    let dest : payoutParam contract = match (Tezos.get_entrypoint_opt "%payout"  store.dest_contract) with
        | None -> failwith "None"
        | Some c -> c
        in 

    let op : operation = Tezos.transaction pa 0tez dest in
    [op], store