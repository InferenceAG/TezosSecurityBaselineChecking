# Store Value - Example for illustrative purposes only.
import smartpy as sp

@sp.module
def main():
    class OrderingContract(sp.Contract):
        def __init__(self, address):
            self.data.destination = address

        @sp.private(with_storage="read-write", with_operations=True)
        def makeTransfers(self):  
            sp.send(self.data.destination, sp.mutez(2000000))
            

        @sp.entrypoint
        def execute(self):
            sp.send(self.data.destination, sp.mutez(1000000))
            self.makeTransfers()
            sp.send(self.data.destination, sp.mutez(3000000))

    class CheckContract(sp.Contract):
        def __init__(self, ):
            self.data.counter = 0

        @sp.entrypoint
        def default(self):
             if self.data.counter == 0:
                assert (sp.amount == sp.mutez(1000000))
                self.data.counter += 1
             else:
                if self.data.counter == 1:
                    assert (sp.amount == sp.mutez(2000000))
                    self.data.counter += 1
                else:
                    if self.data.counter == 2:
                        assert (sp.amount == sp.mutez(3000000))
                        self.data.counter += 1
                    else:
                        raise "fail"
     
@sp.add_test(name = "ordering") 
def test():
    scenario = sp.test_scenario(main)
    checkContract = main.CheckContract()
    scenario += checkContract
    orderingContract = main.OrderingContract(checkContract.address)
    orderingContract.set_initial_balance(sp.mutez(6000000))
    scenario += orderingContract

    scenario.h1("Ordering")        
    orderingContract.execute().run()