#!/usr/bin/env bash

if [ -n "$1" ]; then
    TEST_TARGET="$1"
else
    TEST_TARGET="all"
fi


set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

READLINK='readlink'

[[ `uname` == 'Darwin' ]] && {
	which greadlink > /dev/null && {
		READLINK='greadlink'
	} || {
		echo 'ERROR: GNU utils required for Mac. You may use homebrew to install them: brew install coreutils gnu-sed'
		exit 1
	}
}

SCRIPT_DIR=$(dirname $($READLINK -f "$0"))
BASE_DIR=$(dirname "$SCRIPT_DIR")

###
 # Relative dir
 #
 # $1     -> build target (eg. "bootstrap", "base", "php" ...)
 # stdout -> "1" if target is matched
 #
 ##
function checkTestTarget() {
    if [ "$TEST_TARGET" == "all" -o "$TEST_TARGET" == "$1" ]; then
        echo 1
    fi
}


function initEnvironment() {
    bundle install --path=vendor
}

function runTest() {
    DOCKER_IMAGE="$1"
    SPEC_PATH="$2"

    echo ">>> Testing $DOCKER_IMAGE with $SPEC_PATH"

    echo "FROM $DOCKER_IMAGE" > "${SCRIPT_DIR}/Dockerfile"

    #docker-compose stop
    #docker-compose rm --force
    #docker-compose build --no-cache
    #docker-compose up -d

    TARGET="$DOCKER_IMAGE" bundle exec rspec --pattern "$SPEC_PATH"

    rm -f "${SCRIPT_DIR}/Dockerfile"
}


initEnvironment

#######################################
# webdevops/base
#######################################

[[ $(checkTestTarget base) ]] && {
    echo "Testing webdevops/base..."
    runTest     "webdevops/base:ubuntu-12.04"    "spec/base/ubuntu_spec.rb"
    runTest     "webdevops/base:ubuntu-14.04"    "spec/base/ubuntu_spec.rb"
    runTest     "webdevops/base:ubuntu-15.04"    "spec/base/ubuntu_spec.rb"
    runTest     "webdevops/base:ubuntu-15.10"    "spec/base/ubuntu_spec.rb"

    runTest     "webdevops/base:centos-7"        "spec/base/centos_spec.rb"

    runTest     "webdevops/base:debian-7"        "spec/base/debian_spec.rb"
    runTest     "webdevops/base:debian-8"        "spec/base/debian_spec.rb"
}

#######################################
# webdevops/php
#######################################

[[ $(checkTestTarget php) ]] && {
    echo "Testing webdevops/php..."
    runTest     "webdevops/php:ubuntu-12.04"    "spec/php/ubuntu_spec.rb"
    runTest     "webdevops/php:ubuntu-14.04"    "spec/php/ubuntu_spec.rb"
    runTest     "webdevops/php:ubuntu-15.04"    "spec/php/ubuntu_spec.rb"
    runTest     "webdevops/php:ubuntu-15.10"    "spec/php/ubuntu_spec.rb"

    runTest     "webdevops/php:centos-7"        "spec/php/centos_spec.rb"

    runTest     "webdevops/php:debian-7"        "spec/php/debian_spec.rb"
    runTest     "webdevops/php:debian-8"        "spec/php/debian_spec.rb"
}

#######################################
# webdevops/apache
#######################################

[[ $(checkTestTarget apache) ]] && {
    echo "Testing webdevops/apache..."
    #runTest    "webdevops/apache:ubuntu-12.04"    "spec/apache/ubuntu_spec.rb"
    runTest     "webdevops/apache:ubuntu-14.04"    "spec/apache/ubuntu_spec.rb"
    runTest     "webdevops/apache:ubuntu-15.04"    "spec/apache/ubuntu_spec.rb"
    runTest     "webdevops/apache:ubuntu-15.10"    "spec/apache/ubuntu_spec.rb"

    runTest     "webdevops/apache:centos-7"        "spec/apache/centos_spec.rb"

    runTest     "webdevops/apache:debian-7"        "spec/apache/debian_spec.rb"
    runTest     "webdevops/apache:debian-8"        "spec/apache/debian_spec.rb"
}

#######################################
# webdevops/nginx
#######################################

[[ $(checkTestTarget nginx) ]] && {
    echo "Testing webdevops/nginx..."
    #runTest    "webdevops/nginx:ubuntu-12.04"    "spec/nginx/ubuntu_spec.rb"
    runTest     "webdevops/nginx:ubuntu-14.04"    "spec/nginx/ubuntu_spec.rb"
    runTest     "webdevops/nginx:ubuntu-15.04"    "spec/nginx/ubuntu_spec.rb"
    runTest     "webdevops/nginx:ubuntu-15.10"    "spec/nginx/ubuntu_spec.rb"

    runTest     "webdevops/nginx:centos-7"        "spec/nginx/centos_spec.rb"

    runTest     "webdevops/nginx:debian-7"        "spec/nginx/debian_spec.rb"
    runTest     "webdevops/nginx:debian-8"        "spec/nginx/debian_spec.rb"
}

#######################################
# webdevops/php-apache
#######################################

[[ $(checkTestTarget php-apache) ]] && {
    echo "Testing webdevops/php-apache..."
    #runTest    "webdevops/php-apache:ubuntu-12.04"    "spec/php-apache/ubuntu_spec.rb"
    runTest     "webdevops/php-apache:ubuntu-14.04"    "spec/php-apache/ubuntu_spec.rb"
    runTest     "webdevops/php-apache:ubuntu-15.04"    "spec/php-apache/ubuntu_spec.rb"
    runTest     "webdevops/php-apache:ubuntu-15.10"    "spec/php-apache/ubuntu_spec.rb"

    runTest     "webdevops/php-apache:centos-7"        "spec/php-apache/centos_spec.rb"

    runTest     "webdevops/php-apache:debian-7"        "spec/php-apache/debian_spec.rb"
    runTest     "webdevops/php-apache:debian-8"        "spec/php-apache/debian_spec.rb"
}

#######################################
# webdevops/php-nginx
#######################################

[[ $(checkTestTarget php-nginx) ]] && {
    echo "Testing webdevops/php-nginx..."
    runTest     "webdevops/php-nginx:ubuntu-12.04"    "spec/php-nginx/ubuntu_spec.rb"
    runTest     "webdevops/php-nginx:ubuntu-14.04"    "spec/php-nginx/ubuntu_spec.rb"
    runTest     "webdevops/php-nginx:ubuntu-15.04"    "spec/php-nginx/ubuntu_spec.rb"
    runTest     "webdevops/php-nginx:ubuntu-15.10"    "spec/php-nginx/ubuntu_spec.rb"

    runTest     "webdevops/php-nginx:centos-7"        "spec/php-nginx/centos_spec.rb"

    runTest     "webdevops/php-nginx:debian-7"        "spec/php-nginx/debian_spec.rb"
    runTest     "webdevops/php-nginx:debian-8"        "spec/php-nginx/debian_spec.rb"
}

#######################################
# webdevops/hhvm
#######################################

[[ $(checkTestTarget hhvm) ]] && {
    echo "Testing webdevops/hhvm..."
    runTest     "webdevops/hhvm:ubuntu-14.04"    "spec/hhvm/ubuntu_spec.rb"
}

#######################################
# webdevops/hhvm-apache
#######################################

[[ $(checkTestTarget hhvm-apache) ]] && {
    echo "Testing webdevops/hhvm-apache..."
    runTest     "webdevops/hhvm-apache:ubuntu-14.04"    "spec/hhvm-apache/ubuntu_spec.rb"
}


#######################################
# webdevops/hhvm-nginx
#######################################

[[ $(checkTestTarget hhvm-nginx) ]] && {
    echo "Testing webdevops/hhvm-nginx..."
    runTest     "webdevops/hhvm-nginx:ubuntu-14.04"    "spec/hhvm-nginx/ubuntu_spec.rb"
}
