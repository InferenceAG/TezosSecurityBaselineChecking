# Wrong operators - Example for illustrative purposes only.

import smartpy as sp

@sp.module
def main():

    class Operator(sp.Contract):
        def __init__(self, value):
            self.data.storedValue = value

        @sp.entrypoint
        def update(self):
            x = True
            self.intFunc(x=True)

        @sp.private(with_storage="read-write")
        def intFunc(self, boolVal):
            if boolVal:
                self.data.storedValue = 10
            else:
                self.data.storedValue = 20

if "templates" not in __name__:

    @sp.add_test(name="Test")
    def test():
        c1 = main.Operator(0)
        scenario = sp.test_scenario(main)
        scenario.h1("Test")
        scenario += c1
        c1.update()
        scenario.verify(c1.data.storedValue == 20)
