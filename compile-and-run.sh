#!/bin/bash

set -euo

# this should do, at least for the early days
YEAR=2023
g++ $YEAR/$1.cpp -o $YEAR/exe/$1

$YEAR/exe/$1
