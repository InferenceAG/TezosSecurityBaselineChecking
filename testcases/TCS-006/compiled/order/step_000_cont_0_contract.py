import smartpy as sp

class Contract(sp.Contract):
  def __init__(self):
    self.init_type(sp.TRecord(destination = sp.TAddress).layout("destination"))
    self.init(destination = sp.address('tz1dzdRMe3B9zd158nb18hdaWojfbM2dogqC'))

  @sp.entry_point
  def execute(self, params):
    sp.set_type(params, sp.TLambda(sp.TUnit, sp.TList(sp.TOperation)))
    sp.for op in params(sp.unit).rev():
      sp.operations().push(op)

sp.add_compilation_target("test", Contract())