#!/bin/sh -
reflex -d none -r '\.go$' -s -- sh -c 'go run -tags=debug . 2>&1 | pp'
