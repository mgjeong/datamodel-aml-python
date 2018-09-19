###############################################################################
# Copyright 2017 Samsung Electronics All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
###############################################################################

#!/bin/bash
set +e
#Colors
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NO_COLOUR="\033[0m"

PROJECT_ROOT=$(pwd)
DEP_ROOT=$(pwd)/dependencies
AML_ROOT=${DEP_ROOT}/datamodel-aml-cpp
AML_TARGET_ARCH="$(uname -m)"
AML_WITH_DEP=false
AML_BUILD_MODE="release"
AML_CPP_REPO="git@github.sec.samsung.net:RS7-EdgeComputing/datamodel-aml-cpp.git"


clone_dataModel(){
    echo -e "Building dependencies now\n"
    # Check, clone, build python-ezmq-cpp.
    cd ${DEP_ROOT}
    
    if [ -d "./datamodel-aml-cpp" ]; then
        printf "Datamodel aml cpp directory already exists.\n\nIgnoring clone.\nBuilding again\n\n"
    else
        git clone ${AML_CPP_REPO}
    fi
}


build_x86() {
    echo -e "Building for x86"
    if [ ${AML_WITH_DEP} = true ]; then
        clone_dataModel
    else
	if [ -d "./datamodel-aml-cpp" ]; then
		echo "Building datamodel now"
	else
		echo "ERROR: Dependent libraries not present"
		usage
		exit 1
	fi
    fi

    cd ${AML_ROOT}

    ./build_32.sh --build_mode=${AML_BUILD_MODE}

    cd ${PROJECT_ROOT}

    #build cython using setup file.
    if [ ${AML_BUILD_MODE} == "debug" ]; then
        python setup.py build_ext --inplace -Ddebug
    else
	python setup.py build_ext --inplace
    fi
}

build_x86_64() {
    echo -e "Build for x86_64"
    if [ ${AML_WITH_DEP} = true ]; then
        clone_dataModel
    else
        if [ -d "./datamodel-aml-cpp" ]; then
                echo "Building datamodel now"
        else
                echo "ERROR: Dependent libraries not present"
                usage
                exit 1
        fi
    fi

    cd ${AML_ROOT}

    ./build.sh --build_mode=${AML_BUILD_MODE}

    cd ${PROJECT_ROOT}

    #build cython using setup file.
    if [ ${AML_BUILD_MODE} == "debug" ]; then
	python setup.py build_ext --inplace --debug
    else
	python setup.py build_ext --inplace
    fi
}

usage() {
    echo -e "${BLUE}Usage:${NO_COLOUR} ./build_auto.sh <option>"
    echo -e "${GREEN}Options:${NO_COLOUR}"
    echo "  --target_arch=[x86|x86_64]                                         :  Choose Target Architecture"
    echo "  --with_dependencies=(default: false)                               :  Build ezmq-python along with dependencies [ezmp-cpp, zmq and protobuf]"
    echo "  --build_mode=[release|debug](default: release)                     :  Build ezmq library and samples in release or debug mode"
    echo "  -c                                                                 :  Clean ezmq Repository and its dependencies"
    echo "  -h / --help                                                        :  Display help and exit"
    echo -e "${GREEN}Examples: ${NO_COLOUR}"
    echo -e "${BLUE}  build:-${NO_COLOUR}"
    echo "  $ ./build_auto.sh --target_arch=x86"
    echo "  $ ./build_auto.sh --with_dependencies=true --target_arch=x86"
    echo -e "${BLUE}  debug mode build:-${NO_COLOUR}"
    echo "  $ ./build_auto.sh --target_arch=x86 --build_mode=debug"
    echo -e "${BLUE}  clean:-${NO_COLOUR}"
    echo "  $ ./build_auto.sh -c"
    echo -e "${BLUE}  help:-${NO_COLOUR}"
    echo "  $ ./build_auto.sh -h"
    echo -e "${GREEN}Notes: ${NO_COLOUR}"
    echo "  - While building newly for any architecture use -with_dependencies=true option."
}

build() {
    if [ "x86" = ${AML_TARGET_ARCH} ]; then
         build_x86; exit 0;
    elif [ "i686" = ${AML_TARGET_ARCH} ]; then
         build_x86; exit 0;
    elif [ "x86_64" = ${AML_TARGET_ARCH} ]; then
         build_x86_64; exit 0;
    else
         echo -e "${RED}Not a supported architecture${NO_COLOUR}"
         usage; exit 1;
    fi
}

process_cmd_args() {
    if [ "$#" -eq 0  ]; then
        echo -e "No argument.."
        usage; exit 1
    fi

    while [ "$#" -gt 0  ]; do
        case "$1" in
            --with_dependencies=*)
                AML_WITH_DEP="${1#*=}";
                if [ ${AML_WITH_DEP} = true ]; then
                    echo -e "${GREEN}Build with depedencies${NO_COLOUR}"
                elif [ ${AML_WITH_DEP} = false ]; then
                    echo -e "${GREEN}Build without depedencies${NO_COLOUR}"
                else
                    echo -e "${GREEN}Build without depedencies${NO_COLOUR}"
                    shift 1; exit 0
                fi
                shift 1;
                ;;
            --target_arch=*)
                AML_TARGET_ARCH="${1#*=}";
                echo -e "${GREEN}Target Arch is: $AML_TARGET_ARCH${NO_COLOUR}"
                shift 1
                ;;
            --build_mode=*)
                AML_BUILD_MODE="${1#*=}";
                echo -e "${GREEN}Build mode is: $AML_BUILD_MODE${NO_COLOUR}"
                shift 1;
                ;;
            -c)
                clean_ezmq
                shift 1; exit 0
                ;;
            -h)
                usage; exit 0
                ;;
            --help)
                usage; exit 0
                ;;
            -*)
                echo -e "${RED}"
                echo "unknown option: $1" >&2;
                echo -e "${NO_COLOUR}"
                usage; exit 1
                ;;
            *)
                echo -e "${RED}"
                echo "unknown option: $1" >&2;
                echo -e "${NO_COLOUR}"
                usage; exit 1
                ;;
        esac
    done
}

process_cmd_args "$@"
build
