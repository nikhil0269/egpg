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

cmd_init() {
    # make sure that dependencies are installed
    test $(which haveged) || fail "You should install haveged:\n    sudo apt-get install haveged"
    test $(which parcimonie) || fail "You should install parcimonie:\n    sudo apt-get install parcimonie"

    # check for an existing directory
    if [[ -d $EGPG_DIR ]]; then
        if yesno "There is an old directory '$EGPG_DIR'. Do you want to erase it?"; then
            # stop the gpg-agent if it is running
            if [[ -f "$EGPG_DIR/.gpg-agent-info" ]]; then
                kill -9 $(cut -d: -f 2 "$EGPG_DIR/.gpg-agent-info") 2>/dev/null
                rm -rf $(dirname $(cut -d: -f 1 "$EGPG_DIR/.gpg-agent-info")) 2>/dev/null
                rm "$EGPG_DIR/.gpg-agent-info"
            fi
            # erase the old directory
            [[ -d "$EGPG_DIR" ]] && rm -rfv "$EGPG_DIR"
        fi
    fi

    # create the new $EGPG_DIR
    export EGPG_DIR="$HOME/.egpg"
    [[ -n "$2" ]] && export EGPG_DIR="$2"
    mkdir -pv "$EGPG_DIR"

    # setup $GNUPGHOME
    GNUPGHOME="$EGPG_DIR/.gnupg"
    mkdir -pv "$GNUPGHOME"
    [[ -f "$GNUPGHOME/gpg-agent.conf" ]] || cat <<_EOF > "$GNUPGHOME/gpg-agent.conf"
pinentry-program /usr/bin/pinentry
default-cache-ttl 300
max-cache-ttl 999999
_EOF

    # setup environment variables
    _env_setup ~/.bashrc
}

_env_setup() {
    local env_file=$1
    sed -i $env_file -e '/^### start egpg config/,/^### end egpg config/d'
    cat <<_EOF >> $env_file
### start egpg config
export EGPG_DIR="$EGPG_DIR"
_EOF
    cat <<'_EOF' >> $env_file
# Does ".gpg-agent-info" exist and points to gpg-agent process accepting signals?
if ! test -f "$EGPG_DIR/.gpg-agent-info" \
|| ! kill -0 $(cut -d: -f 2 "$EGPG_DIR/.gpg-agent-info") 2>/dev/null
then
    gpg-agent --daemon --no-grab \
        --options "$EGPG_DIR/.gnupg/gpg-agent.conf" \
        --pinentry-program /usr/bin/pinentry \
        --write-env-file "$EGPG_DIR/.gpg-agent-info" > /dev/null
fi
### end egpg config
_EOF
    echo -e "\nAppended the following lines to '$env_file':\n---------------8<---------------"
    sed $env_file -n -e '/^### start egpg config/,/^### end egpg config/p'
    echo "--------------->8---------------
Please realod it to enable the new config:
    source $env_file
"
}