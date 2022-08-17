#!/bin/sh

cd "${0%/*}/src" || exit

# pp is preprocessor from https://github.com/denisde4ev/pp
exec pp YN_confirm.sh.preprocessed > ../YN_confirm.sh
