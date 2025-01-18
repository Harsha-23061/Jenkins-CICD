#!/bin/bash

# Define the base directory
bitbucket_path="/home/user/repos"

# Validate the base directory
if [ ! -d "$bitbucket_path" ]; then
    echo "Error: Directory $bitbucket_path does not exist."
    exit 1
fi

# Move to the specified path
cd "$bitbucket_path" || { echo "Failed to cd to $bitbucket_path"; exit 1; }

# List all folders in the directory
folders=($(find "$bitbucket_path" -maxdepth 1 -type d -printf '%f\n'))

# Iterate through folders and create scripts
for folder in "${folders[@]}"; do
    # Skip the base directory itself
    if [ "$folder" == "$(basename "$bitbucket_path")" ]; then
        continue
    fi

    # Remove trailing slash from folder name
    folder_name=$(echo "$folder" | sed 's|/$||')

    # Create a new script file with 'dev-' prefix
    script_file="dev-${folder_name}.sh"

    # Check if the script file already exists
    if [ -f "$script_file" ]; then
        echo "Script $script_file already exists. Skipping."
        continue
    fi

    # Define the script content
    script_content="#!/bin/bash

cd ${bitbucket_path}/${folder_name}/ || { echo 'Failed to cd to ${bitbucket_path}/${folder_name}/'; exit 1; }
git branch
git checkout dev-01 || { echo 'Failed to checkout dev-01 branch'; exit 1; }
git status
git pull || { echo 'Failed to pull latest changes'; exit 1; }

if [ -f 'docker_dev_run.sh' ]; then
    bash docker_dev_run.sh
else
    echo 'docker_dev_run.sh not found. Skipping.'
fi"

    # Save the content to the script file
    echo "$script_content" > "$script_file"

    # Make the script executable
    chmod +x "$script_file"

    echo "Script $script_file created."
done
