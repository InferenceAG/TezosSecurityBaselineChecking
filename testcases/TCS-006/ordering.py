# Store Value - Example for illustrative purposes only.
import smartpy as sp

@sp.module
def main():
    class OrderingContract(sp.Contract):
        def __init__(self, address):
            self.data.destination = address

        @sp.entrypoint
        def execute(self, execution_payload):
            sp.cast(execution_payload, sp.lambda_[sp.unit, sp.list[sp.operation]])
                    
            ops = execution_payload()
            for op in ops:
                # We do not reverse the ops list first, since the crafted operations in the lambda is in the order [1tez op,2tez op,3tez op]
                sp.operations.push(op)
                # List is now [tez3 op, tez2 op, tez1 op], which is then executed by SmartPy in reverse order: https://smartpy.io/manual/syntax/operations#manual-operation-management

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
    # no real checks here.