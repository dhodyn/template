#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
TMP_DIR="$(mktemp -d)"
source "${SCRIPT_DIR}/lib/colours.sh"
source "${SCRIPT_DIR}/lib/logging.sh"

usage() {
	cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] [-f] -p param_value arg1 [arg2...]

Script description here.

Available options:

-h, --help      Print this help and exit
-v, --verbose   Print script debug info
-f, --flag      Some flag description
-p, --param     Some param description
EOF
	exit
}

cleanup() {
	trap - SIGINT SIGTERM ERR EXIT
	rm -rf "${TMP_DIR}"
}

msg() {
	echo >&2 -e "${1-}"
}

die() {
	local MSG=$1
	local CODE=${2-1} # default exit status 1
	msg "${MSG}"
	exit "${CODE}"
}

parse_params() {
	# default values of variables set from params
	FLAG=0
	PARAM=''

	while :; do
		case "${1-}" in
			-h | --help) usage ;;
			-v | --verbose) set -x ;;
			--no-color) NO_COLOR=1 ;;
			-f | --flag) FLAG=1 ;; # example flag
			-p | --param) # example named parameter
				PARAM="${2-}"
				shift
				;;
			-?*) die "Unknown option: $1" ;;
			*) break ;;
		esac
		shift
	done

	ARGS=("$@")

	# check required params and arguments
	[[ -z "${PARAM-}" ]] && die "Missing required parameter: param"
	[[ ${#ARGS[@]} == 0 ]] && die "Missing script arguments"

	return 0
}

parse_params "$@"

# script logic here

msg "${RED}Read parameters:${RESET}"
msg "- flag: ${FLAG}"
msg "- param: ${PARAM}"
msg "- arguments: ${ARGS[*]-}"
