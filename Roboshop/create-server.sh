#!/bin/bash

AMI_ID="${aws ec2 describe-images --region us-east-1 --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId'}"

echo $AMI_ID