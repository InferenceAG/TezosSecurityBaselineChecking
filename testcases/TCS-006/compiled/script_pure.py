# Store Value - Example for illustrative purposes only.
import smartpy as sp

class OrderingContract(sp.Contract):
    def __init__(self, address):
        self.init(
            destination = address
        )

    @sp.entry_point
    def execute(self, execution_payload):
        sp.set_type(execution_payload, sp.TLambda(
            sp.TUnit, sp.TList(sp.TOperation)))
                
        sp.add_operations(execution_payload(sp.unit))

class CheckContract(sp.Contract):
    def __init__(self, ):
        self.init(
            counter = 0
        )

    @sp.entry_point
    def default(self):
        with sp.if_(self.data.counter == 0):
            sp.verify(sp.amount == sp.mutez(1000000))
            self.data.counter += 1
        with sp.else_():
            with sp.if_(self.data.counter == 1):
                sp.verify(sp.amount == sp.mutez(2000000))
                self.data.counter += 1
            with sp.else_():
                with sp.if_(self.data.counter == 2):
                    sp.verify(sp.amount == sp.mutez(3000000))
                    self.data.counter += 1
                with sp.else_():
                    sp.failwith("fail")
            

if "templates" not in __name__:
    
    @sp.add_test(name = "ordering") 
    def test():
        scenario = sp.test_scenario()
        checkContract = CheckContract()
        scenario += checkContract

sp.add_compilation_target("order", OrderingContract(sp.address("tz1dzdRMe3B9zd158nb18hdaWojfbM2dogqC")))
