setup_colours() {
    if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
	RESET="$(tput sgr0)" 
	BLACK="$(tput setaf 0)"
	RED="$(tput setaf 1)"
	GREEN="$(tput setaf 2)"
	YELLOW="$(tput setaf 3)"
	BLUE="$(tput setaf 4)"
	MAGENTA="$(tput setaf 5)"
	CYAN="$(tput setaf 6)"
	LIGHTGRAY="$(tput setaf 7)"
	GRAY="$(tput setaf 8)"
	LIGHTRED="$(tput setaf 9)"
	LIGHTGREEN="$(tput setaf 10)"
	LIGHTYELLOW="$(tput setaf 11)"
	LIGHTBLUE="$(tput setaf 12)"
	LIGHTPURPLE="$(tput setaf 13)"
	LIGHTCYAN="$(tput setaf 14)"
	WHITE="$(tput setaf 15)"
    else
	RESET=''
	BLACK=''
	RED=''
	GREEN=''
	YELLOW=''
	BLUE=''
	MAGENTA=''
	CYAN=''
	LIGHTGRAY=''
	GRAY=''
	LIGHTRED=''
	LIGHTGREEN=''
	LIGHTYELLOW=''
	LIGHTBLUE=''
	LIGHTPURPLE=''
	LIGHTCYAN=''
	WHITE=''
    fi
}

setup_colours
