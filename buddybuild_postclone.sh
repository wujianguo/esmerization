#!/usr/bin/env bash

cd `dirname $0`
wget http://nightlies.videolan.org/build/ios/MobileVLCKit-UniversalBinary-20160219-1708.zip mobilevlckit.zip

unzip mobilevlckit.zip
mv MobileVLCKit-binary/MobileVLCKit.framework ./

