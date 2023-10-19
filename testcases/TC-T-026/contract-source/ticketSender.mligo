type storage = unit

type callType = unit

type parameter =
| CallA of callType
| CallB of callType
| CallC of callType
| Ticket of (string ticket)

let calla ( store, _param : storage * callType) : operation list * storage =
    let c : address = Tezos.get_sender() in
    let dest : (string ticket) contract = match (Tezos.get_contract_opt c) with
        | None -> failwith "none" 
        | Some c -> c
        in
    let tkt : string ticket = Option.unopt (Tezos.create_ticket "One" 10n) in
    let op : operation = Tezos.transaction tkt 0tez dest in
    [op], store 

let callb ( store, _param : storage * callType) : operation list * storage =
    let c : address = Tezos.get_sender() in
    let dest : (string ticket) contract = match (Tezos.get_entrypoint_opt "%" c) with
        | None -> failwith "none" 
        | Some c -> c
        in
    let tkt : string ticket = Option.unopt (Tezos.create_ticket "One" 10n) in
    let op : operation = Tezos.transaction tkt 0tez dest in
    [op], store 

let callc ( store, _param : storage * callType) : operation list * storage =
    let c : address = Tezos.get_sender() in
    let dest : (string ticket) contract = match (Tezos.get_entrypoint_opt "%any" c) with
        | None -> failwith "none" 
        | Some c -> c
        in
    let tkt : string ticket = Option.unopt (Tezos.create_ticket "One" 10n) in
    let op : operation = Tezos.transaction tkt 0tez dest in
    [op], store 

let main (action, store : parameter * storage) : operation list * storage =
    match action with
        | CallA param -> calla(store, param)
        | CallB param -> callb(store, param)
        | CallC param -> callc(store, param)
        | Ticket _param -> [], store
