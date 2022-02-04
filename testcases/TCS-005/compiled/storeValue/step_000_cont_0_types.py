import smartpy as sp

tstorage = sp.TRecord(magic_one = sp.TBool, storedValue = sp.TIntOrNat).layout(("magic_one", "storedValue"))
tparameter = sp.TVariant(set = sp.TUnit).layout("set")
tprivates = { }
tviews = { }
