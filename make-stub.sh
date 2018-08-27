#!/bin/bash

readelf --dyn-syms -W ${1} | tail -n+4 | awk '$3>0{print "#pragma weak " $8}'
