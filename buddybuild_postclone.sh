#!/usr/bin/env bash

cd `dirname $0`
wget http://nightlies.videolan.org/build/ios/MobileVLCKit-UniversalBinary-20151219-0547.zip -O mobilevlckit.zip

unzip mobilevlckit.zip
mv build/MobileVLCKit.framework ./

