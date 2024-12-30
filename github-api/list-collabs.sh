#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <organization_name> <repository_name>"
    exit 1
fi

# Arguments
ORG_NAME=$1
REPO_NAME=$2

# Ensure environment variables are set
if [ -z "$GITHUB_USERNAME" ] || [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: Please export GITHUB_USERNAME and GITHUB_TOKEN before running the script."
    exit 1
fi

# Make the API request
echo "Fetching collaborators for repository $ORG_NAME/$REPO_NAME..."
RESPONSE=$(curl -s -u $GITHUB_USERNAME:$GITHUB_TOKEN \
    "https://api.github.com/repos/$ORG_NAME/$REPO_NAME/collaborators")

# Check if the request was successful
if [[ $RESPONSE == *"Not Found"* ]]; then
    echo "Error: Repository $ORG_NAME/$REPO_NAME not found or you don't have access."
    exit 1
fi

# Print the list of collaborators
echo "Collaborators with access to $ORG_NAME/$REPO_NAME:"
echo "$RESPONSE" | jq -r '.[] | "\(.login): \(.permissions)"'

