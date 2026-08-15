@echo off
cls
fpc -ghl build.pas -dOPX_PROGRAM -dOPX_TESTS -dOPX_TESTS_RUNNER && build
delp .