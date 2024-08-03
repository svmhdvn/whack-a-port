#!/bin/sh

# bunch of notes and prototyping commands

token="$(cat $HOME/secrets/ghtoken.txt)"
_req() {
    curl --request GET \
    --url "https://api.github.com/$1" \
    --header "Accept: application/vnd.github+json" \
    --header "Authorization: Bearer ${token}"
}

#_req "repos/mawww/kakoune/releases/latest"
_req "repos/bolthole/zrep/releases/latest"

xargs -L1 make -V '${GH_ACCOUNT}/${GH_PROJECT}' -C < playground/gh_ports.txt > playground/gh_repos.txt
