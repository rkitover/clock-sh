#!/bin/sh

main() {
    for req in python toilet tput; do
        if ! command -v $req >/dev/null; then
            printf >&2 "please install $req\n"
            exit 1
        fi
    done

    trap 'tput cnorm; exit' SIGINT

    LINES=$(tput lines)
    COLUMNS=$(tput cols)

    clock=$(render)
    height=$(printf '%s' "$clock" | wc -l)
    width=$(($(printf '%s' "$clock" | head -1 | wc -m) - 1))

    # +1 for ceiling
    center_x=$(((($COLUMNS + 1) / 2) - (($width  + 1) / 2)))
    center_y=$(((($LINES   + 1) / 2) - (($height + 1) / 2)))

    horizontal_centering_spaces=$(dup $(( $center_x - 1 )) ' ')

    clear
    tput civis

    while :; do
        tput cup $(( $center_y - 1 )) 0
        render --metal | sed 's/^/'"$horizontal_centering_spaces"'/'
        sleep_until_next_second
    done  

    tput cnorm
}

render() {
    date +%X | toilet -F border -f ascii12 "$@"
}

dup() {
    awk "BEGIN{ for(i = 0; i < $1; i++) { printf \"$2\" } print; exit }"
}

sleep_until_next_second() {
    python -c 'import time; time.sleep(1 - (time.time_ns() - (int(time.time()) * 1000000000)) / 1000000000)' >/dev/null 2>&1
}

main "$@"
