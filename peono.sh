#!/bin/bash
set -e

CONFIG_PATH="$HOME/.config/peono.conf"
TASKS_FILE=".peonotasks.sh"
LOG_LEVEL=1

_TASKS=()

load_configuration () {
    if [ "${LOG_LEVEL}" -ge 3 ]; then echo "[DEBUG] Configuration file: ${CONFIG_PATH}"; fi

    if [ -d $(dirname "${CONFIG_PATH}") ]; then
        if [ ! -f "${CONFIG_PATH}" ]; then
            touch $CONFIG_PATH
            if [ "${LOG_LEVEL}" -ge 3 ]; then echo "[DEBUG] Initilization configuration"; fi
        fi
        source "${CONFIG_PATH}"
        if [ "${LOG_LEVEL}" -ge 3 ]; then echo "[DEBUG] Configuration loaded"; fi
    fi
    if [ "${LOG_LEVEL}" -ge 3 ]; then echo "[DEBUG] Tasks file: ${TASKS_FILE}"; fi
}

load_tasks () {
    if [ -f "${TASKS_FILE}" ]; then
        source "${TASKS_FILE}"
    fi
    local IFS=$'\n'
    for task_name in $(typeset -F); do
        if [[ "${task_name}" == "declare -f task_"* ]]; then
            local task_name=$(echo ${task_name} | cut -d' ' -f3 | awk -F"task_" '{print $2}')
            _TASKS+=(${task_name})
        fi
    done
    if [ "${LOG_LEVEL}" -ge 3 ]; then echo "[DEBUG] Current tasks loaded"; fi
}

list_tasks () {
    for task in "${_TASKS[@]}"; do
        if [ ! -z "${task}" ]; then
            echo "${task}"
        fi
    done
}

run_task () {
    for task in "${_TASKS[@]}"; do
        if [ "${task}" == "${1}" ]; then
            break
        fi
    done

    if [ "${task}" != "${1}" ]; then
        echo "Task \"${1}\" not found"
        exit 2
    fi

    echo "Running \"${1}\" task (from: $(pwd)/${TASKS_FILE})"
    set +e
    echo -e "\e[1m\e[94m#==========> BEGIN\e[0m"
    eval "task_${1}"
    echo -e "\e[1m\e[94m#==========> END\e[0m"
    set -e
}

usage () {
    echo "Usage: peono [list|l|run|r] TASK"
    exit 1
}

run () {
    case "$1" in
        list|l)
            list_tasks
            ;;
        run|r)
            if [ -z "${2// }" ]; then
              usage
            fi
            run_task ${2}
            ;;
        *)
            usage
            ;;
    esac
}

load_configuration
load_tasks
run "$@"

exit 0