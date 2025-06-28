#!/bin/bash

# Simple script to validate the CloudFormation template

echo "Validating CloudFormation template..."
aws cloudformation validate-template --template-body file://dev-environment.yaml

if [ $? -eq 0 ]; then
    echo "Template validation successful!"
else
    echo "Template validation failed!"
    exit 1
fi

echo "Checking for potential security issues..."
# This is a simple check for common security issues
grep -i "0.0.0.0/0" dev-environment.yaml
if [ $? -eq 0 ]; then
    echo "Warning: Found potential wide-open CIDR (0.0.0.0/0) in the template."
    echo "Consider restricting access in production environments."
fi

echo "Validation complete!"