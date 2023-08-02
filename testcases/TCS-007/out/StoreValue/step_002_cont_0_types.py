import smartpy as sp

tstorage = sp.record(storedValue = sp.intOrNat).layout("storedValue")
tparameter = sp.variant(update = sp.record(value = sp.intOrNat).layout("value")).layout("update")
tprivates = { }
tviews = { }
