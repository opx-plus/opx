#!/bin/sh
set -e

CMD="${1:-run}"

case "$CMD" in
    run)
        fpc -ghl build.pas -dOPX_PROGRAM && ./build
        RESULT=$?
        ;;
    test)
        fpc -ghl build.pas -dOPX_PROGRAM -dOPX_TESTS -dOPX_TESTS_RUNNER && ./build
        RESULT=$?
        ;;
    *)
        echo "Unknown command: $CMD"
        echo "Usage: build.sh [run|test]"
        exit 1
        ;;
esac

delp . 2>/dev/null || true
exit "$RESULT"