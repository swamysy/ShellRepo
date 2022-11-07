#!/bin/bash

AMI_ID="${aws ec2 decsribe-images --region us-east-1 --filters "Name=name, Values=DevOps-LabImage-CentOS7" | jq '.Images[].imageID'}"

echo $AMI_ID