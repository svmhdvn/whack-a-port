#!/usr/bin/env python3

import urllib.request
import json
import time
import pprint
import pathlib

REQINTERVAL = 3600.0/5000.0 # GH rate limit
with open(pathlib.Path.home() / "secrets" / "ghtoken.txt") as f:
    TOKEN = f.read().strip()

def do_req(endpoint):
    req = urllib.request.Request('https://api.github.com/' + endpoint)
    req.add_header('Accept', 'application/vnd.github+json')
    req.add_header('Authorization', 'Bearer ' + TOKEN)

    with urllib.request.urlopen(req) as resp:
        return json.load(resp)

with open('gh_ports_repos.txt') as f:
    ports_and_repos = [l.strip().split() for l in f]

#pprint.pprint(ports_and_repos)

print("PORT\tGH_REPO\tVERSION\tNUM_ASSETS")
for pr in ports_and_repos:
    try:
        j = do_req(f"repos/{pr[1]}/releases/latest")
        version = j["tag_name"]
        num_assets = len(j["assets"])
        print(f"{pr[0]}\t{pr[1]}\t{version}\t{num_assets}", flush=True)
    except Exception as e:
        print(f"{pr[0]}\t{pr[1]}\tERROR\t{e}", flush=True)

    time.sleep(REQINTERVAL)
