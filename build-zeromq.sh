#!/bin/bash

#
# Compile libzmq as MacOS / iOS universal static library
# Supported architectures: armv7 armv7s i386 x86_64
#
# Created by Greg Zubankov
#
# Licensed under ISC License 
# http://opensource.org/licenses/ISC
#
# Copyright (c) 2014 Greg Zubankov
#

IOS_SDK_VERSION=7.0

#
BUILD_DIR=`pwd`/build
XCODE_DIR=`xcode-select --print-path`

#
IOS_SDK=${XCODE_DIR}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${IOS_SDK_VERSION}.sdk
IOS_SIMULATOR_SDK=${XCODE_DIR}/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator${IOS_SDK_VERSION}.sdk

#
ARCH_ARMV7=armv7
ARCH_ARMV7S=armv7s
ARCH_ARM64=arm64
ARCH_I386=i386
ARCH_X86_64=x86_64

#
ARCH_UNIVERSAL=universal
LIBZMQ_NAME=libzmq.a

#
COMMON_LDFLAGS="-stdlib=libc++ -lstdc++"
COMMON_CFLAGS="-DNDEBUG -g -O0 -pipe -fPIC -fcxx-exceptions"
COMMON_CXXFLAGS="-std=c++11 -stdlib=libc++"
COMMON_MIN_IOS_VERSION="-miphoneos-version-min=6.1"

#
LOG_NAME=${BUILD_DIR}/build-zeromq.log

function IsWorkingDirectoryAZeroMQRoot
{
  if [ -f `pwd`/include/zmq.h ]
  then
    return 0
  else
    return 1
  fi
}


function SetCommonEnv
{
  export CPP="cpp"
  export CXXCPP="cpp"
  export CXX="/usr/bin/clang"
  export CC="/usr/bin/clang"
  export AR="/usr/bin/ar"
  export AS="/usr/bin/as"
  export LD="/usr/bin/ld"
  export LIBTOOL="/usr/bin/libtool"
  export STRIP="/usr/bin/strip"
  export RANLIB="/usr/bin/ranlib"
}


function UnsetCommonEnv
{
  unset CPP CXXCPP CXX CC AR AS LD LIBTOOL STRIP RANLIB
}


function CleanAndDeploy
{
  if [[ -d ${BUILD_DIR} ]]; then
    rm -fr ${BUILD_DIR}
  fi

  make clean &> NULL

  mkdir -p ${BUILD_DIR}
  mkdir -p ${BUILD_DIR}/lib
  mkdir -p ${BUILD_DIR}/${ARCH_ARMV7}
  mkdir -p ${BUILD_DIR}/${ARCH_ARMV7S}
  mkdir -p ${BUILD_DIR}/${ARCH_ARM64}
  mkdir -p ${BUILD_DIR}/${ARCH_I386}
  mkdir -p ${BUILD_DIR}/${ARCH_X86_64}
  mkdir -p ${BUILD_DIR}/${ARCH_UNIVERSAL}
}


function CompileZeroMQ_ARMV7
{
  echo "Compiling ${ARCH_ARMV7}..."
  #
  export LDFLAGS="${COMMON_LDFLAGS} ${COMMON_MIN_IOS_VERSION} -arch ${ARCH_ARMV7}"
  export CFLAGS="${COMMON_CFLAGS} ${COMMON_MIN_IOS_VERSION} -arch ${ARCH_ARMV7} -isysroot ${IOS_SDK}"
  export CXXFLAGS="${COMMON_CXXFLAGS} -arch ${ARCH_ARMV7} -isysroot ${IOS_SDK}"
  #
  ./configure --build=x86_64-apple-darwin --host=armv7-apple-darwin --disable-shared --prefix=${BUILD_DIR} --exec_prefix=${BUILD_DIR}/${ARCH_ARMV7} >> ${LOG_NAME} 2>&1
  #
  unset LDFLAGS CFLAGS CXXFLAGS
  #
  if CompileZeroMQ ${BUILD_DIR}/${ARCH_ARMV7}
  then
    echo "Done"
  else
    echo "Failed. Check the log file: ${LOG_NAME}"
  fi
}


function CompileZeroMQ_ARMV7S
{
  echo "Compiling ${ARCH_ARMV7S}..."
  #
  export LDFLAGS="${COMMON_LDFLAGS} ${COMMON_MIN_IOS_VERSION} -arch ${ARCH_ARMV7S}"
  export CFLAGS="${COMMON_CFLAGS} ${COMMON_MIN_IOS_VERSION} -arch ${ARCH_ARMV7S} -isysroot ${IOS_SDK}"
  export CXXFLAGS="${COMMON_CXXFLAGS} -arch ${ARCH_ARMV7S} -isysroot ${IOS_SDK}"
  #
  ./configure --build=x86_64-apple-darwin --host=armv7s-apple-darwin --disable-shared --prefix=${BUILD_DIR} --exec_prefix=${BUILD_DIR}/${ARCH_ARMV7S} >> ${LOG_NAME} 2>&1
  #
  unset LDFLAGS CFLAGS CXXFLAGS
  #
  if CompileZeroMQ ${BUILD_DIR}/${ARCH_ARMV7S}
  then
    echo "Done"
  else
    echo "Failed. Check the log file: ${LOG_NAME}"
  fi
}


function CompileZeroMQ_ARM64
{
  echo "Compiling ${ARCH_ARM64}..."
  #
  export LDFLAGS="${COMMON_LDFLAGS} ${COMMON_MIN_IOS_VERSION} -arch ${ARCH_ARM64}"
  export CFLAGS="${COMMON_CFLAGS} ${COMMON_MIN_IOS_VERSION} -arch ${ARCH_ARM64} -isysroot ${IOS_SDK}"
  export CXXFLAGS="${COMMON_CXXFLAGS} -arch ${ARCH_ARM64} -isysroot ${IOS_SDK}"
  #
  ./configure --build=x86_64-apple-darwin --host=arm-apple-darwin --disable-shared --prefix=${BUILD_DIR} --exec_prefix=${BUILD_DIR}/${ARCH_ARM64} >> ${LOG_NAME} 2>&1
  #
  unset LDFLAGS CFLAGS CXXFLAGS
  #
  if CompileZeroMQ ${BUILD_DIR}/${ARCH_ARM64}
  then
    echo "Done"
  else
    echo "Failed. Check the log file: ${LOG_NAME}"
  fi
}


function CompileZeroMQ_I386
{
  echo "Compiling ${ARCH_I386}..."
  #
  export LDFLAGS="${COMMON_LDFLAGS} ${COMMON_MIN_IOS_VERSION} -arch ${ARCH_I386}"
  export CFLAGS="${COMMON_CFLAGS} ${COMMON_MIN_IOS_VERSION} -arch ${ARCH_I386} -isysroot ${IOS_SIMULATOR_SDK}"
  export CXXFLAGS="${COMMON_CXXFLAGS} -arch ${ARCH_I386} -isysroot ${IOS_SIMULATOR_SDK}"
  #
  ./configure --build=x86_64-apple-darwin --host=i386-apple-darwin --disable-shared --prefix=${BUILD_DIR} --exec_prefix=${BUILD_DIR}/${ARCH_I386} >> ${LOG_NAME} 2>&1
  #
  unset LDFLAGS CFLAGS CXXFLAGS
  #
  if CompileZeroMQ ${BUILD_DIR}/${ARCH_I386}
  then
    echo "Done"
  else
    echo "Failed. Check the log file: ${LOG_NAME}"
  fi
}

function CompileZeroMQ_X86_64
{
  echo "Compiling ${ARCH_X86_64}..."
  #
  export LDFLAGS="${COMMON_LDFLAGS} -arch ${ARCH_X86_64}"
  export CFLAGS="${COMMON_CFLAGS} -arch ${ARCH_X86_64}"
  export CXXFLAGS="${COMMON_CXXFLAGS} -arch ${ARCH_X86_64}"
  #
  ./configure --disable-shared --prefix=${BUILD_DIR} --exec_prefix=${BUILD_DIR}/${ARCH_X86_64} >> ${LOG_NAME} 2>&1
  #
  unset LDFLAGS CFLAGS CXXFLAGS
  #
  if CompileZeroMQ ${BUILD_DIR}/${ARCH_X86_64}
  then
    echo "Done"
  else
    echo "Failed. Check the log file: ${LOG_NAME}"
  fi
}

function CompileZeroMQ
{
  make src >> ${LOG_NAME} 2>&1
  make install >> ${LOG_NAME} 2>&1
  make clean &> NULL
  #
  if [ -f $1/lib/${LIBZMQ_NAME} ]
  then
    return 0
  else
    return 1
  fi
}

function CreateUniversalLibrary
{
  echo "Creating universal library..."
  lipo \
    ${BUILD_DIR}/${ARCH_ARMV7}/lib/${LIBZMQ_NAME} \
    ${BUILD_DIR}/${ARCH_ARMV7S}/lib/${LIBZMQ_NAME} \
    ${BUILD_DIR}/${ARCH_ARM64}/lib/${LIBZMQ_NAME} \
    ${BUILD_DIR}/${ARCH_I386}/lib/${LIBZMQ_NAME} \
    ${BUILD_DIR}/${ARCH_X86_64}/lib/${LIBZMQ_NAME} \
    -create -output ${BUILD_DIR}/${ARCH_UNIVERSAL}/${LIBZMQ_NAME}

  lipo ${BUILD_DIR}/${ARCH_UNIVERSAL}/${LIBZMQ_NAME} -info
}

function CopyUniversalLibraryToDefaultPath
{
  if cp ${BUILD_DIR}/${ARCH_UNIVERSAL}/${LIBZMQ_NAME} ${BUILD_DIR}/lib/${LIBZMQ_NAME}
  then
    echo "-----------------------------"
    echo "The univeral library is here: ${BUILD_DIR}/lib/${LIBZMQ_NAME}"
    echo "Thank you for using this script! Don't forget to add '-lstdc++' to the 'Other Linker Flags' option here: 'Build Settings/Linking'."
  else
    echo "Something was wrong. Please check these files: "
  fi
}

function Main
{
  echo "Building ZeroMQ for Mac OS / iOS."
  echo "Build requirements: OS Mavericks, XCode >= 5"
  echo "Tested with ZeroMQ 4.0.3"
  echo ""

  if ! IsWorkingDirectoryAZeroMQRoot
  then
    echo "error: Working directory is not a zeromq root."
    exit 1
  fi

  CleanAndDeploy
  SetCommonEnv

  CompileZeroMQ_ARMV7
  CompileZeroMQ_ARMV7S
  CompileZeroMQ_ARM64
  CompileZeroMQ_I386
  CompileZeroMQ_X86_64

  CreateUniversalLibrary
  CopyUniversalLibraryToDefaultPath

  UnsetCommonEnv
}


Main