#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testCompile()
{
  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertEquals 0 ${rtrn}
  assertEquals "" "`cat ${STD_ERR}`"

  assertContains "-----> Vendoring imageutils"  "`cat ${STD_OUT}`"
  assertContains "       Downloading https://github.com/jonathantron/heroku-buildpack-imageutils/releases/download/1.0.0/imageutils-1.0.0.tar.gz"  "`cat ${STD_OUT}`"
  assertContains "       Extracting to ${BUILD_DIR}/vendor/imageutils"  "`cat ${STD_OUT}`"

  assertTrue "Should have cached imageutils `ls -la ${CACHE_DIR}`" "[ -f ${CACHE_DIR}/imageutils-1.0.0.tar.gz ]"
  assertFileMD5 "b948a803614f221b6af364b20df5aa07" "${CACHE_DIR}/imageutils-1.0.0.tar.gz"

  assertTrue "Should have installed imageutils in vendor build dir: `ls -l ${BUILD_DIR}/vendor/`" "[ -d ${BUILD_DIR}/vendor/imageutils ]"

  assertContains "-----> Building runtime environment"  "`cat ${STD_OUT}`"
  assertTrue "Should have created profile.d/imageutils.sh `ls -l ${BUILD_DIR}/.profile.d/`"  "[ -f ${BUILD_DIR}/.profile.d/imageutils.sh ]"
  assertContains "export PATH=\"/app/vendor/imageutils/bin:"  "`cat ${BUILD_DIR}/.profile.d/imageutils.sh`"

  # Run again to ensure cache is used.
  rm -rf ${BUILD_DIR}/*
  resetCapture

  capture ${BUILDPACK_HOME}/bin/compile ${BUILD_DIR} ${CACHE_DIR}
  assertContains    "-----> Vendoring imageutils"  "`cat ${STD_OUT}`"
  assertContains    "       Skip download - found in cache"  "`cat ${STD_OUT}`"
  assertNotContains "       Downloading https://github.com/jonathantron/heroku-buildpack-imageutils/releases/download/1.0.0/imageutils-1.0.0.tar.gz"  "`cat ${STD_OUT}`"
  assertContains    "       Extracting to ${BUILD_DIR}/vendor/imageutils"  "`cat ${STD_OUT}`"

  assertTrue "Should have installed imageutils in vendor build dir: `ls -l ${BUILD_DIR}/vendor/`" "[ -d ${BUILD_DIR}/vendor/imageutils ]"

  assertContains "-----> Building runtime environment"  "`cat ${STD_OUT}`"
  assertTrue "Should have created profile.d/imageutils.sh `ls -l ${BUILD_DIR}/.profile.d/`"  "[ -f ${BUILD_DIR}/.profile.d/imageutils.sh ]"
  assertContains "export PATH=\"/app/vendor/imageutils/bin:"  "`cat ${BUILD_DIR}/.profile.d/imageutils.sh`"

  assertEquals 0 ${rtrn}
  assertEquals "" "`cat ${STD_ERR}`"
}
