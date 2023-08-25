import smartpy as sp

tstorage = sp.record(destination = sp.address).layout("destination")
tparameter = sp.variant(execute = sp.unit).layout("execute")
tprivates = { "makeTransfers": sp.lambda_(sp.unit, sp.unit, with_storage="read-write", tstorage=sp.record(destination = sp.address).layout("destination"), with_operations=True) }
tviews = { }
