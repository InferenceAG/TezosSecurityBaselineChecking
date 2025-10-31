# Testcase title: Address index

## Description

This scenario checks the address indexing feature.

### Expected results

INDEX_ADDRESS and GET_ADDRESS_INDEX are global indexes for "addresses".

### Note

address_index.tz inserts a NAT 0, since otherelse the contract would fail ("big_map or sapling_state type not expected here
")). Not sure why this happens. Reported to NL.