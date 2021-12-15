#!/bin/sh
cat ./install-app.sh >> ./input/frame-img-custom.sh

CHANGE_ME=/mnt/e/WinIdeaWork/CZTemManager/oms-hardware

cp ${CHANGE_ME}/target/omshard.jar ./input/app.jar
mkdir ./input/lib
mkdir ./input/page
cp ${CHANGE_ME}/target/lib/* ./input/lib
cp -R ${CHANGE_ME}/../src/main/resources/page/* ./input/page