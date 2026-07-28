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

stdout() {
    echo -e "${1-}"
}

stderr() {
    echo >&2 -e "${1-}"
}

terminate() {
    local message=$1
    local exit_code=${2-1}  # default exit status 1
    stderr "${message}"
    exit "${exit_code}"
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
            -f | --flag) FLAG=1 ;;  # example flag
            -p | --param)  # example named parameter
                PARAM="${2-}"
                shift
                ;;
            -?*) terminate "Unknown option: $1" ;;
            *) break ;;
        esac
        shift
    done

    ARGS=("$@")

    # check required params and arguments
    [[ -z "${PARAM-}" ]] && terminate "Missing required parameter: param"
    [[ ${#ARGS[@]} == 0 ]] && terminate "Missing script arguments"

    return 0
}

main() {
    stderr "${RED}Read parameters:${RESET}"
    stderr "- flag: ${FLAG}"
    stderr "- param: ${PARAM}"
    stderr "- arguments: ${ARGS[*]-}"
}

parse_params "$@"
main
