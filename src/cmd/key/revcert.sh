# Generate a revocation certificate for the key.

cmd_key_revcert_help() {
    cat <<-_EOF
    revcert ["description"]
        Generate a revocation certificate for the key.

_EOF
}

cmd_key_revcert() {
    echo "Creating a revocation certificate."
    local description=${1:-"Key is being revoked"}

    get_gpg_key
    revoke_cert="$EGPG_DIR/$GPG_KEY.revoke"
    rm -f "$revoke_cert"

    gnupghome_setup
    local commands="y|1|$description||y"
    commands=$(echo "$commands" | tr '|' "\n")
    script -c "gpg --yes --command-fd=0 --output \"$revoke_cert\" --gen-revoke $GPG_KEY <<< \"$commands\" " /dev/null > /dev/null
    while [[ -n $(ps ax | grep -e '--gen-revoke' | grep -v grep) ]]; do sleep 0.5; done
    call_fn qrencode "$revoke_cert"
    [[ -f "$revoke_cert" ]] &&  echo -e "Revocation certificate saved at: \n    \"$revoke_cert\""
    [[ -f "$revoke_cert.pdf" ]] &&  echo -e "    \"$revoke_cert.pdf\""
    gnupghome_reset
    return 0
}

#
# This file is part of EasyGnuPG.  EasyGnuPG is a wrapper around GnuPG
# to simplify its operations.  Copyright (C) 2016 Dashamir Hoxha
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses/
#
