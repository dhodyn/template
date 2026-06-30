_log() {
    local msg
    msg=$1
    echo >&2 -e "$(date +'%Y-%m-%dT%H:%M:%S.%N%z') - ${msg:-}"
}

log_info() {
    local msg
    msg=$1
    _log "INFO - ${msg:-}"
}

log_warn() {
    local msg
    msg=$1
    _log "WARN - ${msg:-}"
}

log_error() {
    local msg
    msg=$1
    local exit_code
    exit_code=${2-1}
    _log "ERROR - ${msg:-}"
    exit "${exit_code}"
}
