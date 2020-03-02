#!/bin/sh

main() {
    for req in tput toilet; do
        if ! command -v $req >/dev/null; then
            printf >&2 "ERROR: please install $req"
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

    while :; do
        tput cup 0 0
        printf "$centering_spaces"
        render | sed 's/^/'"$horizontal_centering_spaces"'/'
        sleep 1
    done  

    tput cnorm
}

render() {
    date +%X | toilet --metal -F border -f ascii12
}

main "$@"
