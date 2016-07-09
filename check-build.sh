#!/bin/bash -e
. /etc/profile.d/modules.sh
module load ci
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
make check

echo $?

make install
mkdir -p ${REPO_DIR}
mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION."
setenv       MATLAB_VERSION       $VERSION
setenv       MATLAB_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(MATLAB_DIR)/lib
MODULE_FILE
) > modules/$VERSION

mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/$VERSION ${LIBRARIES_MODULES}/${NAME}
