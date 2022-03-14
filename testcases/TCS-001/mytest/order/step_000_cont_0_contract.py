import smartpy as sp

class Contract(sp.Contract):
  def __init__(self):
    self.init_type(sp.TRecord(destination = sp.TAddress).layout("destination"))
    self.init(destination = sp.address('tz1dzdRMe3B9zd158nb18hdaWojfbM2dogqC'))

  @sp.entry_point
  def execute(self):
    sp.send(self.data.destination, sp.tez(1))
    sp.send(self.data.destination, sp.tez(2))
    sp.send(self.data.destination, sp.tez(3))

sp.add_compilation_target("test", Contract())