#!/bin/bash

AMI_ID="$(aws ec2 describe-images --region us-east-1 --filters "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImageId' | sed -e 's/"//g')"
SG_ID="$(aws ec2 describe-security-groups --filters Name=group-name,Values=b51-allow-all | jq '.SecurityGroups[].GroupId' | sed -e 's/"//g')"
echo "AMI ID Used to launch instance is : $AMI_ID"
echo "SG ID Used to launch instance is : $SG_ID"
COMPONENT=$1
echo $COMPONENT
#aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" | jq

aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SG_ID  --instance-market-options "MarketType=spot, SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehaviour=stop}" --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" | jq