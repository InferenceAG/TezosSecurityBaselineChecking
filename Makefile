.PHONY: help build test test-single lint accounts check-accounts

NETWORK ?= latest
FILTER  ?=
TC      ?=

help:
	@echo "Tezos Security Baseline Checking Framework"
	@echo ""
	@echo "Targets:"
	@echo "  make build            Build the Docker image"
	@echo "  make test             Run all test cases (native)"
	@echo "  make test-docker      Run all test cases (Docker)"
	@echo "  make test-single TC=TC-001  Run a single test case"
	@echo "  make lint             Run shellcheck on all .sh files"
	@echo "  make accounts         Create test accounts"
	@echo "  make check-accounts   Check account balances"
	@echo ""
	@echo "Variables:"
	@echo "  NETWORK=latest        Network argument passed to execute_all.sh"
	@echo "  FILTER=TC-T           Only run test cases matching this prefix"
	@echo "  TC=TC-001             Test case to run with test-single"

build:
	docker compose build

test:
	cd _framework && bash execute_all.sh $(NETWORK) $(if $(FILTER),--filter $(FILTER),)

test-docker:
	docker compose run --rm test-runner $(NETWORK) $(if $(FILTER),--filter $(FILTER),)

test-single:
	@if [ -z "$(TC)" ]; then echo "Usage: make test-single TC=TC-001"; exit 1; fi
	cd testcases/$(TC) && bash execute_test.sh $(NETWORK)

lint:
	find . -name "*.sh" -not -path "./testcases/python-env/*" \
	    -exec shellcheck --severity=warning {} +

accounts:
	cd _framework && bash create_accounts.sh

check-accounts:
	cd _framework && bash check_accounts.sh
