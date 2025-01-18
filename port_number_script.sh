#!/bin/bash

# Specify the full path to repo.txt file
repo_txt_path="/home/user/repos/repo_list.txt"

# Validate the repo.txt file
if [ ! -f "$repo_txt_path" ]; then
    echo "Error: repo.txt file not found at $repo_txt_path."
    exit 1
fi

# Create config file if it doesn't exist
if [ -f "config.txt" ]; then
    echo "config.txt already exists. Appending to it."
else
    touch "config.txt"
    chmod 600 "config.txt"  # Restrict permissions to owner only
fi

# Initialize counter if not already set
counter=${counter:-1000}

# Loop through each repo in repo.txt
while IFS= read -r repo_url; do
    # Validate repository URL
    if [[ ! "$repo_url" =~ ^https://github.com/ ]]; then
        echo "Invalid repository URL: $repo_url. Skipping."
        continue
    fi

    # Extract repository name from the URL
    repo_name=$(echo "$repo_url" | awk -F'/' '{print $NF}' | sed 's/\.git$//')

    # Check if the repo entry already exists in config.txt
    if grep -q "Repo: $repo_name," config.txt; then
        echo "Repo: $repo_name already exists in config.txt"
    else
        # Generate a random subdomain
        subdomain=$(openssl rand -hex 4)  # Generates a random 8-character string

        # Append to the config file with the current counter value
        echo "Repo: $repo_name, Subdomain: $subdomain.demo.ai, Port: $counter" >> config.txt
        echo "Repo: $repo_name, Subdomain: $subdomain.demo.ai, Port: $counter added to config.txt"

        # Increment the counter for the next iteration
        ((counter++))
    fi
done < "$repo_txt_path"

echo "Config file updated successfully: config.txt"
