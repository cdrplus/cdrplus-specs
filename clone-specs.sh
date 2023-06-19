#!/bin/bash

REPOS="cdrplus-infosec-baseline cdrplus-sharing-arrangement-v1 cdrplus-admission-control cdrplus-enhanced-errors"

[ ! -d "specs" ] && mkdir specs

for SPEC in $REPOS
  do
    [ ! -d "specs/$SPEC" ] && git clone git@github.com:cdrplus/$SPEC.git specs/$SPEC
  done
