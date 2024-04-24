#!/bin/bash

# generates lcov.info
forge coverage --ir-minimum  --report lcov


lcov --version

# forge does not instrument libraries https://github.com/foundry-rs/foundry/issues/4854
EXCLUDE="*test* *testFoundry* *external* *mock* *node_modules* $(grep -r 'library' contracts -l)"
lcov --rc lcov_branch_coverage=1 \
    --output-file forge-pruned-lcov.info \
    --remove lcov.info $EXCLUDE \
    --ignore-errors unused

if [ "$CI" != "true" ]; then
    genhtml --rc branch_coverage=1 \
        --output-directory coverage forge-pruned-lcov.info \
        --ignore-errors category \
        --ignore-errors unmapped \
        --dark-mode \
        --show-details \
        && open coverage/index.html
fi
