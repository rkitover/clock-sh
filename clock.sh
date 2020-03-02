#!/bin/sh

for req in tput toilet; do
    if ! command -v $req >/dev/null; then
        printf >&2 "ERROR: please install $req"
        exit 1
    fi
done

trap 'tput cnorm; exit 0' SIGINT

clear
tput civis

while :; do
    tput cup 0 0
    date +%X | toilet --metal -F border -f ascii12
    sleep 1
done  

tput cnorm
