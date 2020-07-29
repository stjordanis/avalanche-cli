#!/usr/bin/env bash
###############################################################################

function cmd {
    printf "./avalanche-cli.sh avm create-address" ;
}

function check {
    local result="$1" ;
    local result_u ; result_u=$(printf '%s' "$result" | cut -d' ' -f3) ;
    local result_h ; result_h=$(printf '%s' "$result" | cut -d' ' -f5) ;
    local result_d ; result_d=$(printf '%s' "$result" | cut -d' ' -f7) ;
    local expect_u ; expect_u="'127.0.0.1:9650/ext/bc/${2-X}'" ;
    assertEquals "$expect_u" "$result_u" ;
    local expect_h ; expect_h="'content-type:application/json'" ;
    assertEquals "$expect_h" "$result_h" ;
    local expect_d ; expect_d="'{" ;
    expect_d+='"jsonrpc":"2.0",' ;
    expect_d+='"id":1,' ;
    expect_d+='"method":"avm.createAddress",' ;
    expect_d+='"params":{' ;
    expect_d+='"username":"USERNAME",' ;
    expect_d+='"password":"PASSWORD"' ;
    expect_d+="}}'" ;
    assertEquals "$expect_d" "$result_d" ;
    local expect="curl --url $expect_u --header $expect_h --data $expect_d" ;
    assertEquals "$expect" "$result" ;
}

function test_avm__create_address_1a {
    check "$(AVA_ID_RPC=1 $(cmd) -u USERNAME -p PASSWORD)" ;
}

function test_avm__create_address_1b {
    check "$(AVA_ID_RPC=1 AVA_USERNAME=USERNAME $(cmd) -p PASSWORD)" ;
}

function test_avm__create_address_1c {
    check "$(AVA_ID_RPC=1 AVA_PASSWORD=PASSWORD $(cmd) -u USERNAME)" ;
}

function test_avm__create_address_2a {
    check "$(AVA_ID_RPC=1 $(cmd) \
        -u USERNAME -p PASSWORD -b BC_ID)" BC_ID ;
}

function test_avm__create_address_2b {
    check "$(AVA_ID_RPC=1 AVA_BLOCKCHAIN_ID=BC_ID $(cmd) \
        -u USERNAME -p PASSWORD -b BC_ID)" BC_ID ;
}

###############################################################################
###############################################################################
