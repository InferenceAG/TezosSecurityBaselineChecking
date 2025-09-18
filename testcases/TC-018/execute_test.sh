#!/bin/bash
. ../../_framework/init.sh
. ../../_framework/functions.sh

getTestcaseTitle

removeContract "compare_addresses"

# See information regarding "compare" of addresses: https://tezos.gitlab.io/michelson-reference/#instr-COMPARE

# tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU -> 06a19f0000000000000000000000000000000000000000
# tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs -> 06a19f9c3c5a33f9350cfcbe46ab07ccaecc6792365101
# tz1iydgEAWLmDA7qqDXwPsXEJRXWa9LZHgXV -> 06a19fffffffffffffffffffffffffffffffffffffffff

# tz28KEfLTo3wg2wGyJZMjC1MaDA1q68s6tz5 -> 06a1a10000000000000000000000000000000000000000
# tz2RTSZwShS8sMrZeiwBgcEV1pHmXdr24Ta8 -> 06a1a1bc0767caed44e599bb6e7fb7aaf52442b0eb2205
# tz2XeqeSm5m88uki7Pan4WVUqznX62jhf7ir -> 06a1a1ffffffffffffffffffffffffffffffffffffffff

# tz3LL3cfMfBV4fPaPZdcj9TjPa3XbvLiXw9V -> 06a1a40000000000000000000000000000000000000000
# tz3hFmPknoR4hYYbQxG1NXx3WkAWMvAidftW -> 06a1a4e58b6f8c2460dfb0b753df13fdd6fd17f99da2f5
# tz3jfebmewtfXYD1Xef34TwrfMg2rrrw6oum -> 06a1a4ffffffffffffffffffffffffffffffffffffffff

# tz491FasxEbqzR2SfjgTPnRyw9JY7og2HZUA -> 06a1a60000000000000000000000000000000000000000
# tz4Bi1Y7MU4dbwhtawPpHH5ShZxfrZz1Byiv -> 06a1a61da5945c9342d7a680eb96caa460fd07e2244b01
# tz4YLrZzFXK2THqsophsj6v7Cvw3NkN6Ad3n -> 06a1a6ffffffffffffffffffffffffffffffffffffffff

# KT18amZmM5W7qDWVt2pH6uj7sCEd3kbzLrHT -> 025a790000000000000000000000000000000000000000
# KT1PWx2mnDueood7fEmfbBDKx1D9BAnnXitn -> 025a79a3d0f58d8964bd1b37fb0a0c197b38cf46608d49
# KT1XvNYseNDJJ6Kw27qhSEDF8ys8JhDopzfG -> 025a79ffffffffffffffffffffffffffffffffffffffff

# sr163Lv22CdE8QagCwf48PWDTquk6isQwv57 -> 067c750000000000000000000000000000000000000000
# sr1Ghq66tYK9y3r8CC1Tf8i8m5nxh8nTvZEf -> 067c7574f8952e7a287d78e8dceec67547bd00a278abbf
# sr1VNwu8KVLQbHQ7M2gUThzLjdYFMfa9sRSf -> 067c75ffffffffffffffffffffffffffffffffffffffff

case $1 in
	oxford)
		echo "executing tests for $1"	

		# Check the ordering of addresses in the comment above.
		echo "## Sub testcase #1:"
		$TEZOSCLIENT originate contract compare_addresses transferring 0 from deploy running compare_addresses.tz --burn-cap 1 --force >result1a.tmp 2>&1
		checkResult result1a.tmp "Contract memorized as compare_addresses."
	
		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU" "tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs")' --entrypoint "default" >result1b.tmp 2>&1
		checkResult result1b.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz1Zt8QQ9aBznYNk5LUBjtME9DuExomw9YRs" "tz1iydgEAWLmDA7qqDXwPsXEJRXWa9LZHgXV")' --entrypoint "default" >result1c.tmp 2>&1
		checkResult result1c.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz1iydgEAWLmDA7qqDXwPsXEJRXWa9LZHgXV" "tz28KEfLTo3wg2wGyJZMjC1MaDA1q68s6tz5")' --entrypoint "default" >result1d.tmp 2>&1
		checkResult result1d.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz28KEfLTo3wg2wGyJZMjC1MaDA1q68s6tz5" "tz2RTSZwShS8sMrZeiwBgcEV1pHmXdr24Ta8")' --entrypoint "default" >result1e.tmp 2>&1
		checkResult result1e.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz2RTSZwShS8sMrZeiwBgcEV1pHmXdr24Ta8" "tz2XeqeSm5m88uki7Pan4WVUqznX62jhf7ir")' --entrypoint "default" >result1f.tmp 2>&1
		checkResult result1f.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz2XeqeSm5m88uki7Pan4WVUqznX62jhf7ir" "tz3LL3cfMfBV4fPaPZdcj9TjPa3XbvLiXw9V")' --entrypoint "default" >result1g.tmp 2>&1
		checkResult result1g.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz3LL3cfMfBV4fPaPZdcj9TjPa3XbvLiXw9V" "tz3hFmPknoR4hYYbQxG1NXx3WkAWMvAidftW")' --entrypoint "default" >result1h.tmp 2>&1
		checkResult result1h.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz3hFmPknoR4hYYbQxG1NXx3WkAWMvAidftW" "tz3jfebmewtfXYD1Xef34TwrfMg2rrrw6oum")' --entrypoint "default" >result1i.tmp 2>&1
		checkResult result1i.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz3jfebmewtfXYD1Xef34TwrfMg2rrrw6oum" "tz491FasxEbqzR2SfjgTPnRyw9JY7og2HZUA")' --entrypoint "default" >result1j.tmp 2>&1
		checkResult result1j.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz491FasxEbqzR2SfjgTPnRyw9JY7og2HZUA" "tz4Bi1Y7MU4dbwhtawPpHH5ShZxfrZz1Byiv")' --entrypoint "default" >result1k.tmp 2>&1
		checkResult result1k.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz4Bi1Y7MU4dbwhtawPpHH5ShZxfrZz1Byiv" "tz4YLrZzFXK2THqsophsj6v7Cvw3NkN6Ad3n")' --entrypoint "default" >result1l.tmp 2>&1
		checkResult result1l.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz4YLrZzFXK2THqsophsj6v7Cvw3NkN6Ad3n" "KT18amZmM5W7qDWVt2pH6uj7sCEd3kbzLrHT")' --entrypoint "default" >result1m.tmp 2>&1
		checkResult result1m.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "KT18amZmM5W7qDWVt2pH6uj7sCEd3kbzLrHT" "KT1PWx2mnDueood7fEmfbBDKx1D9BAnnXitn")' --entrypoint "default" >result1n.tmp 2>&1
		checkResult result1n.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "KT1PWx2mnDueood7fEmfbBDKx1D9BAnnXitn" "KT1XvNYseNDJJ6Kw27qhSEDF8ys8JhDopzfG")' --entrypoint "default" >result1o.tmp 2>&1
		checkResult result1o.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "KT1XvNYseNDJJ6Kw27qhSEDF8ys8JhDopzfG" "sr163Lv22CdE8QagCwf48PWDTquk6isQwv57")' --entrypoint "default" >result1p.tmp 2>&1
		checkResult result1p.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "sr163Lv22CdE8QagCwf48PWDTquk6isQwv57" "sr1Ghq66tYK9y3r8CC1Tf8i8m5nxh8nTvZEf")' --entrypoint "default" >result1q.tmp 2>&1
		checkResult result1q.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "sr1Ghq66tYK9y3r8CC1Tf8i8m5nxh8nTvZEf" "sr1VNwu8KVLQbHQ7M2gUThzLjdYFMfa9sRSf")' --entrypoint "default" >result1r.tmp 2>&1
		checkResult result1r.tmp "The operation has only been included 0 blocks ago."

		# additional check to verify ordering of types of addresses.
		echo "## Sub testcase #2:"
		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU" "sr163Lv22CdE8QagCwf48PWDTquk6isQwv57")' --entrypoint "default" >result2a.tmp 2>&1
		checkResult result2a.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz28KEfLTo3wg2wGyJZMjC1MaDA1q68s6tz5" "sr163Lv22CdE8QagCwf48PWDTquk6isQwv57")' --entrypoint "default" >result2b.tmp 2>&1
		checkResult result2b.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz3LL3cfMfBV4fPaPZdcj9TjPa3XbvLiXw9V" "sr163Lv22CdE8QagCwf48PWDTquk6isQwv57")' --entrypoint "default" >result2c.tmp 2>&1
		checkResult result2c.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz491FasxEbqzR2SfjgTPnRyw9JY7og2HZUA" "sr163Lv22CdE8QagCwf48PWDTquk6isQwv57")' --entrypoint "default" >result2d.tmp 2>&1
		checkResult result2d.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU" "KT18amZmM5W7qDWVt2pH6uj7sCEd3kbzLrHT")' --entrypoint "default" >result2e.tmp 2>&1
		checkResult result2e.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz28KEfLTo3wg2wGyJZMjC1MaDA1q68s6tz5" "KT18amZmM5W7qDWVt2pH6uj7sCEd3kbzLrHT")' --entrypoint "default" >result2f.tmp 2>&1
		checkResult result2f.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz3LL3cfMfBV4fPaPZdcj9TjPa3XbvLiXw9V" "KT18amZmM5W7qDWVt2pH6uj7sCEd3kbzLrHT")' --entrypoint "default" >result2g.tmp 2>&1
		checkResult result2g.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU" "tz491FasxEbqzR2SfjgTPnRyw9JY7og2HZUA")' --entrypoint "default" >result2h.tmp 2>&1
		checkResult result2h.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz28KEfLTo3wg2wGyJZMjC1MaDA1q68s6tz5" "tz491FasxEbqzR2SfjgTPnRyw9JY7og2HZUA")' --entrypoint "default" >result2i.tmp 2>&1
		checkResult result2i.tmp "The operation has only been included 0 blocks ago."

		$TEZOSCLIENT transfer 0 from admin to compare_addresses --arg '(Pair "tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU" "tz3LL3cfMfBV4fPaPZdcj9TjPa3XbvLiXw9V")' --entrypoint "default" >result2j.tmp 2>&1
		checkResult result2j.tmp "The operation has only been included 0 blocks ago."

		;;

	*)
		echo "not supported $1"
		;;	
esac
rm *.tmp
