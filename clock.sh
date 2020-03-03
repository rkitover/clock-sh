#!/bin/sh

main() {
    for req in tput toilet; do
        if ! command -v $req >/dev/null; then
            printf >&2 "ERROR: please install $req\n"
            exit 1
        fi
    done

    trap 'tput cnorm; exit 0' SIGINT

    clear
    tput civis

    clock=$(render)
    height=$(printf $clock | wc -l)
    width=$(( $(printf $clock | head -1 | wc -m) - 1 ))

    center_x=$(( ($COLUMNS / 2) - ($width  / 2) ))
    center_y=$(( ($LINES   / 2) - ($height / 2) ))

    centering_spaces=$(           awk 'BEGIN{ for(i = 0; i < '$(( ($center_y * $COLUMNS) ))'; i++) { printf " " } print; exit }')
    horizontal_centering_spaces=$(awk 'BEGIN{ for(i = 0; i < '$center_x';                     i++) { printf " " } print; exit }')

    printf "$centering_spaces"

    while :; do
        tput cup $center_y 0
        render | sed 's/^/'"$horizontal_centering_spaces"'/'
        # Sleep until next second.
        sleep $(printf "scale=3; 1 - $(date +%N) / 1000000000\n" | bc)
    done  

    tput cnorm
}

render() {
    date +%X | toilet --metal -F border -f ascii12
}

main "$@"
