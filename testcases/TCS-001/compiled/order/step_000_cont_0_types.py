import smartpy as sp

tstorage = sp.TRecord(admin = sp.TAddress).layout("admin")
tparameter = sp.TVariant(execute = sp.TUnit).layout("execute")
tprivates = { }
tviews = { }
