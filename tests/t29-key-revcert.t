#!/usr/bin/env bash

test_description='Command: key revcert'
source "$(dirname "$0")"/setup.sh

test_expect_success 'egpg key revcert' '
    egpg_init &&
    egpg_key_fetch &&
    egpg key revcert "test" &&
    local revoke_file="$EGPG_DIR/$KEY_ID.revoke" &&
    [[ -f "$revoke_file" ]] &&
    [[ -f "$revoke_file.pdf" ]]
'

test_done
