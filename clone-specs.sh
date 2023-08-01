#!/bin/bash

REPOS="datarightplus-infosec-baseline datarightplus-sharing-arrangement-v1 datarightplus-admission-control-baseline datarightplus-error-codes-baseline"

[ ! -d "specs" ] && mkdir specs

for SPEC in $REPOS
  do
    [ ! -d "specs/$SPEC" ] && git clone git@github.com:datarightplus/$SPEC.git specs/$SPEC
  done
