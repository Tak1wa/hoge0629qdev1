#!/bin/bash

# Script to deploy the CloudFormation stack

# Check if key pair name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <key-pair-name>"
    echo "Example: $0 my-key-pair"
    exit 1
fi

KEY_NAME=$1
STACK_NAME="dev-environment"

echo "Deploying CloudFormation stack with key pair: $KEY_NAME"

# Validate template first
./validate-template.sh
if [ $? -ne 0 ]; then
    echo "Template validation failed. Aborting deployment."
    exit 1
fi

# Deploy the stack
aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://dev-environment.yaml \
    --parameters ParameterKey=KeyName,ParameterValue=$KEY_NAME \
    --capabilities CAPABILITY_IAM

if [ $? -eq 0 ]; then
    echo "Stack creation initiated. Waiting for stack to complete..."
    aws cloudformation wait stack-create-complete --stack-name $STACK_NAME
    
    if [ $? -eq 0 ]; then
        echo "Stack creation completed successfully!"
        echo "Stack outputs:"
        aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs" --output table
    else
        echo "Stack creation failed or timed out. Check AWS CloudFormation console for details."
    fi
else
    echo "Failed to initiate stack creation."
fi