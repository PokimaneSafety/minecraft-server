#!/usr/bin/env bash
export $(grep -v '^#' .env | xargs -d '\n')
command "$@"
