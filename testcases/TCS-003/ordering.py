# Store Value - Example for illustrative purposes only.
import smartpy as sp

class OrderingContract(sp.Contract):
    def __init__(self, address):
        self.init(
            destination = address
        )

    @sp.private_lambda(with_storage="read-write", with_operations=True, wrap_call=True)
    def makeTransfers(self):  
        sp.send(self.data.destination, sp.mutez(2000000))
        

    @sp.entry_point
    def execute(self):
        sp.send(self.data.destination, sp.mutez(1000000))
        self.makeTransfers()
        sp.send(self.data.destination, sp.mutez(3000000))

class CheckContract(sp.Contract):
    def __init__(self, ):
        self.init(
            counter = 0
        )

    @sp.entry_point
    def default(self):
        sp.if self.data.counter == 0:
            sp.verify(sp.amount == sp.mutez(1000000))
            self.data.counter += 1
        sp.else:
            sp.if self.data.counter == 1:
                sp.verify(sp.amount == sp.mutez(2000000))
                self.data.counter += 1
            sp.else:
                sp.if self.data.counter == 2:
                    sp.verify(sp.amount == sp.mutez(3000000))
                    self.data.counter += 1
                sp.else:
                    sp.failwith("fail")
            

if "templates" not in __name__:
    
    @sp.add_test(name = "ordering") 
    def test():
        scenario = sp.test_scenario()
        checkContract = CheckContract()
        scenario += checkContract
        orderingContract = OrderingContract(checkContract.address)
        orderingContract.set_initial_balance(sp.mutez(6000000))
        scenario += orderingContract

        scenario.h1("Ordering")        
        scenario = orderingContract.execute().run()

sp.add_compilation_target("order", OrderingContract(sp.address("tz1dzdRMe3B9zd158nb18hdaWojfbM2dogqC")))