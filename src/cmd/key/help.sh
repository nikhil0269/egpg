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

cmd_key_help() {
    cat <<-_EOF

Usage: $(basename $0) key <command> [<options>]

Commands to manage the key. They are listed below.

    gen,generate [<email> <name>] [-n,--no-passphrase]
        Create a new GPG key. If <email> and <name> are not given as
        arguments, they will be asked interactively.

    [ls,list,show] [-r,--raw | -c,--colons] [-a,--all]
        Show the details of the key (optionally in raw format or with
        colons). A list of all the keys can be displayed as well
        (including the revoked and expired ones).

    rm,del,delete [<key-id>]
        Delete the key.

    exp,export [<key-id>]
        Export key to file.

    imp,import <file>
        Import key from file.

    fetch [-d,--homedir <gnupghome>] [-k,--key-id <key-id>]
        Get a key from another gpg directory (by default from $GNUPGHOME).

    renew,expiration [<date>]
        Renew the key until the given date (by default 1 month from now).
        The <date> is in free time format, like "2 months", 2020-11-15,
        "March 7", "5 years" etc. The date formats are those that are
        accepted by the command `date -d` (see `info date`).

    revcert ["description"]
        Generate a revocation certificate for the key.

    rev,revoke [<revocation-certificate>]
        Cancel the key by publishing the given revocation certificate.

    pass
        Change the passphrase.

    share
        Publish the key to the keyserver network.

_EOF
}