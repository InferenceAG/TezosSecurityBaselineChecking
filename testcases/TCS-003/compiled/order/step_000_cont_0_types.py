import smartpy as sp

tstorage = sp.TRecord(destination = sp.TAddress).layout("destination")
tparameter = sp.TVariant(execute = sp.TUnit).layout("execute")
tprivates = { "makeTransfers": sp.TLambda(sp.TUnit, sp.TUnit, with_storage="read-write", with_operations=True) }
tviews = { }
