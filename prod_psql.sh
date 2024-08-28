#!/bin/bash

source "$(dirname "$0")/detect_os.sh"

FLY_COMMAND=$(detect_os)

$FLY_COMMAND postgres connect -a pistadb -d pista
