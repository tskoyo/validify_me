#!/bin/bash

# Set the necessary variables
repo=$(basename -s .git `git config --get remote.origin.url`)
branch_name=$(git rev-parse --abbrev-ref HEAD)
base_branch="master"
pr_body=$2

# Push the new branch to remote
git push origin $branch_name

# Create a new pull request using the GitHub API
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer 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"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/Ckojo/$repo/pulls" \
  -d "{\"title\":\"$branch_name\",\"body\":\"$pr_body\",\"head\":\"$branch_name\",\"base\":\"$base_branch\"}" \

# Extract the pull request URL from the response
# pr_url=$($response | jq -r '.url')

# Output the pull request URL
echo "Pull request created"
