# Store Value - Example for illustrative purposes only.

import smartpy as sp

class StoreValue(sp.Contract):
    def __init__(self, value):
        self.init(storedValue = value, magic_one = True)

    @sp.entry_point
    def set(self):
        storedValue = sp.local("storedValue", self.data.storedValue)
        if self.data.magic_one:
            storedValue.value = 1
        else:
            storedValue.value = 2
        self.data.storedValue = storedValue.value

if "templates" not in __name__:
    @sp.add_test(name = "StoreValue")
    def test():
        c1 = StoreValue(12)
        scenario = sp.test_scenario()
        scenario.h1("Store Value")
        scenario += c1
        scenario = c1.set()

    sp.add_compilation_target("storeValue", StoreValue(12))
