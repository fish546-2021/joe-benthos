#!/bin/bash
set -e
set -u
set -o pipefail

test -d ./test01_aln ; echo $? # is this a directory ?
test -d ./test02_aln ; echo $? # is this a directory ?
