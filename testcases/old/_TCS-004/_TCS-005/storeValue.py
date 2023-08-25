# Store Value - Example for illustrative purposes only.

import smartpy as sp

@sp.module
def main():
    class StoreValue(sp.Contract):
        def __init__(self, value):
            self.data.storedValue = value
            self.data.magic_one = True

        @sp.entrypoint
        def set(self):
            storedValue = self.data.storedValue
            if storedValue == 0:
                storedValue = 1
            else:
                storedValue = 0
            self.data.storedValue = storedValue

@sp.add_test(name = "StoreValue")
def test():
    scenario = sp.test_scenario(main)
    c1 = main.StoreValue(0)
    scenario.h1("Store Value")
    scenario += c1
    c1.set()
    scenario.verify(c1.data.storedValue == 1)
