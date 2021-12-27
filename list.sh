#!/bin/bash +x
if [ -z "$1" ] ; then
      echo "Please pass the description of the AMI"
      exit 1
fi

IMAGE_FILTER="${1}"

declare -a REGIONS=($(aws ec2 describe-regions --output json | jq '.Regions[].RegionName' | tr "\\n" " " | tr -d '\\"'))
for r in "${REGIONS[@]}" ; 
do
    ami=$(aws ec2 describe-images --owners self --query 'Images[*].[ImageId]' --filters "Name=description,Values=*${IMAGE_FILTER}*" --region ${r} --output json | jq '.[0][0]')
    echo "${r} = ${ami}"
done
