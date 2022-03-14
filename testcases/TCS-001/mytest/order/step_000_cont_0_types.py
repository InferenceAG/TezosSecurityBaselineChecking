import smartpy as sp

tstorage = sp.TRecord(destination = sp.TAddress).layout("destination")
tparameter = sp.TVariant(execute = sp.TUnit).layout("execute")
tprivates = { }
tviews = { }
