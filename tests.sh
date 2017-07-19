#!/bin/bash

setup() {
    set -euo pipefail
    export LOG_LEVEL=0
    rm -rf ${TESTS_CACHE}/tmp
    mkdir -p ${TESTS_CACHE}/tmp
    cd ${TESTS_CACHE}/tmp
    set +euo pipefail
}

teardown() {
    set -euo pipefail
    rm -rf ${TESTS_CACHE}/tmp 
    set +euo pipefail
}

test_no_tasks_file() {
    assert "${PEONO} l" ""
    assert "${PEONO} list" ""
}

test_empty_tasks_file() {
    echo > .peonotasks.sh
    assert "${PEONO} l" ""
    assert "${PEONO} list" ""
}

test_list_tasks() {
    echo "task_hello () { echo \"Hello world!\"; }" > .peonotasks.sh
    echo "task_hello_2 () { echo \"Hello world!\"; }" >> .peonotasks.sh

    assert "${PEONO} l" "hello\nhello_2\n"
    assert "${PEONO} list" "hello\nhello_2\n"
}

test_list_tasks_with_not_tasks_function() {
    echo "taskk_hello () { echo \"Hello world!\"; }" > .peonotasks.sh
    echo "ttask_hello () { echo \"Hello world!\"; }" >> .peonotasks.sh

    assert "${PEONO} l" ""
    assert "${PEONO} list" ""
}

test_run_task() {
    echo "task_hello () { echo \"Hello world!\"; }" > .peonotasks.sh
    assert "${PEONO} r hello" "Hello world!\n"
    assert "${PEONO} run hello" "Hello world!\n"
}

test_not_exists_task() {
    echo "task_hello () { echo \"Hello world!\"; }" > .peonotasks.sh
    assert "${PEONO} r jambon" "Task \"jambon\" not found"
    assert "${PEONO} run jambon" "Task \"jambon\" not found"
}

test_same_name_tasks() {
    echo "task_hello () { echo \"Hello world!\"; }" > .peonotasks.sh
    echo "task_hello () { echo \"Hello world 2!\"; }" >> .peonotasks.sh
    assert "${PEONO} r hello" "Hello world 2!"
    assert "${PEONO} run hello" "Hello world 2!"
}

test_load_tasks_file_variable() {
    TASKS_FILE=jambon.foe
    echo "task_hello () { echo \"Hello world!\"; }" > .peonotasks.sh
    echo "task_hello () { echo \"Hello world 2!\"; }" > jambon.foe
    assert "${PEONO} r hello" "Hello world!"
    assert "${PEONO} run hello" "Hello world!"
}

. .assert.sh