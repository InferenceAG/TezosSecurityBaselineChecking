# Wrong operators - Example for illustrative purposes only.

import smartpy as sp


@sp.module
def main():
    class Operator(sp.Contract):
        def __init__(self, value):
            self.data.storedValue = value

        @sp.entrypoint
        def update(self, params):
            x = False;
    
            if (x=True):
                self.data.storedValue = 10
            self.data.storedValue = params.value

if "templates" not in __name__:

    @sp.add_test(name="Wrong operator case 1")
    def test():
        c1 = main.Operator(0)
        scenario = sp.test_scenario(main)
        scenario.h1("Wrong operator")
        scenario += c1
        c1.update(value=20)
        scenario.verify(c1.data.storedValue == 20)
