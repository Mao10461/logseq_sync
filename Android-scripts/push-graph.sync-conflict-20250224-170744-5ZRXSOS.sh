#!/usr/bin/bash
source bin/source-ssh-agent
cd ~/storage/shared/Documents/MyGraph
git add -A
git commit -m "sync from android"
git push
