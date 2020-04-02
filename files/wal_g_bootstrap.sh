#!/usr/bin/env bash

while getopts ":-:" optchar; do
  [[ "${optchar}" == "-" ]] || continue
  case "${OPTARG}" in
    datadir=* )
        DATA_DIR=${OPTARG#*=}
        ;;
    scope=* )
        SCOPE=${OPTARG#*=}
        ;;
  esac
done

wal-g backup-fetch $DATA_DIR LATEST
