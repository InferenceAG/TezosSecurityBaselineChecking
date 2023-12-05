type transferParam = {
    contractAddress: address;
    payoutAmount: tez;
}

type storage = {
    dest : address; 
    level: nat;
}

let main ( _action, store : unit * storage): operation list * storage =
    if (Tezos.get_level() <> store.level) 
    then
        let pa : transferParam = {
            contractAddress = Tezos.get_self_address();
            payoutAmount = 3tez;
        } in

        let dest : transferParam contract = match Tezos.get_entrypoint_opt "%transfer" store.dest with
            | None -> failwith "none"
            | Some c -> c
            in
            
        let op : operation = Tezos.transaction pa 0tez dest in
        [op], {store with level = Tezos.get_level()}
    else
        [], {store with level = Tezos.get_level()}
    
