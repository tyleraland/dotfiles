#!/bin/bash

set -e

# drop into python shell to determine package's actual version
check_version(){
    # usage: check_version module version-string
    "$PYTHON" <<EOF 2> /dev/null
import $1
from distutils.version import LooseVersion
assert LooseVersion($1.__version__) >= LooseVersion("$2")
EOF
}

VENV=$1
VENV_VERSION=1.11.6
PYTHON=$(which python)

# create virtualenv if necessary, downloading source if available
# version is not up to date
VENV_URL="https://pypi.python.org/packages/source/v/virtualenv"
if [[ ! -f "${VENV:?}/bin/activate" ]]; then
    # if the system virtualenv is up to date, use it
    if check_version virtualenv $VENV_VERSION; then
	echo "using $(which virtualenv) (version $(virtualenv --version))"
    	virtualenv "$VENV"
    else
	echo "downloading virtualenv version $VENV_VERSION"
	if [[ ! -f ~/.src/virtualenv-${VENV_VERSION}/virtualenv.py ]]; then
	    mkdir -p ~/.src
	    (cd ~/.src && \
		wget -N ${VENV_URL}/virtualenv-${VENV_VERSION}.tar.gz && \
		tar -xf virtualenv-${VENV_VERSION}.tar.gz)
	fi
	"$PYTHON" ~/.src/virtualenv-${VENV_VERSION}/virtualenv.py "$VENV"
    fi
else
    echo "virtualenv $VENV already exists"
fi

