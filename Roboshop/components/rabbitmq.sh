#!/bin/bash
set -e

COMPONENT=rabbitmq
APPUSER=roboshop
source components/common.sh

NODEJS

echo -n "_______________$COMPONENT Installation is Successful______________"