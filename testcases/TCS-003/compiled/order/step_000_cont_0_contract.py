import smartpy as sp

class Contract(sp.Contract):
  def __init__(self):
    self.init_type(sp.TRecord(destination = sp.TAddress).layout("destination"))
    self.init(destination = sp.address('tz1dzdRMe3B9zd158nb18hdaWojfbM2dogqC'))

  @sp.entry_point
  def execute(self):
    sp.send(self.data.destination, sp.tez(1))
    compute_ordering_31i = sp.local("compute_ordering_31i", self.makeTransfers(sp.unit))
    sp.send(self.data.destination, sp.tez(3))

  @sp.private_lambda()
  def makeTransfers(_x0):
    sp.send(self.data.destination, sp.tez(2))

sp.add_compilation_target("test", Contract())