import smartpy as sp

class Contract(sp.Contract):
  def __init__(self):
    self.init_type(sp.TRecord(magic_one = sp.TBool, storedValue = sp.TIntOrNat).layout(("magic_one", "storedValue")))
    self.init(magic_one = True,
              storedValue = 12)

  @sp.entry_point
  def set(self):
    storedValue = sp.local("storedValue", self.data.storedValue)
    sp.if self.data.magic_one:
      storedValue.value = 1
    sp.else:
      storedValue.value = 0
    self.data.storedValue = storedValue.value

sp.add_compilation_target("test", Contract())