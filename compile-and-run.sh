#!/bin/bash



# this should do, at least for the early days
YEAR=2023
g++ $YEAR/$1.cpp -o $YEAR/exe/$1 -std=c++17

$YEAR/exe/$1
