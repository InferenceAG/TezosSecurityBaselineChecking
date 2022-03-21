import smartpy as sp

tstorage = sp.TRecord(destination = sp.TAddress).layout("destination")
tparameter = sp.TVariant(execute = sp.TLambda(sp.TUnit, sp.TList(sp.TOperation))).layout("execute")
tprivates = { }
tviews = { }
