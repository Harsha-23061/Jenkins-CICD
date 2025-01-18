#!/bin/bash

# Set the base path for Repo
base_path="/home/user/repos/"

# Validate the base directory
if [ ! -d "$base_path" ]; then
    echo "Error: Directory $base_path does not exist."
    exit 1
fi

# Validate config.txt
if [ ! -f "config.txt" ]; then
    echo "Error: config.txt not found."
    exit 1
fi

# Read config.txt line by line
while IFS=', ' read -r repo_name subdomain port; do
    # Sanitize inputs
    repo_name=$(echo "$repo_name" | tr -cd '[:alnum:]-_')
    subdomain=$(echo "$subdomain" | tr -cd '[:alnum:]-_')
    port=$(echo "$port" | tr -cd '[:digit:]')

    # Validate port
    if [[ ! "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1024 ] || [ "$port" -gt 65535 ]; then
        echo "Invalid port: $port. Skipping."
        continue
    fi

    # Create Repo directory if it doesn't exist
    repo_dir="$base_path/$repo_name"
    mkdir -p "$repo_dir" || { echo "Failed to create directory $repo_dir"; exit 1; }

    # Create Dockerfile content
    dockerfile_content="FROM nginx:latest\n\
    COPY . /usr/share/nginx/html\n\
    WORKDIR /usr/share/nginx/html\n\
    CMD [\"nginx\", \"-g\", \"daemon off;\"]"

    # Create Dockerfile if it doesn't exist
    dockerfile_path="$repo_dir/Dockerfile-new"
    if [ -f "$dockerfile_path" ]; then
        echo "File $dockerfile_path already exists. Skipping."
    else
        echo -e "$dockerfile_content" > "$dockerfile_path"
    fi

    # Create Docker run script content
    docker_run_content="#!/bin/sh\n\
    git checkout dev-01 || { echo 'Failed to checkout dev-01 branch'; exit 1; }\n\
    git pull origin dev-01 || { echo 'Failed to pull latest changes'; exit 1; }\n\
    docker stop dev-$repo_name || true && docker rm dev-$repo_name || true\n\
    docker build -t dev-$repo_name -f Dockerfile-new . || { echo 'Failed to build Docker image'; exit 1; }\n\
    docker run -d -p $port:$port --name dev-$repo_name dev-$repo_name || { echo 'Failed to run Docker container'; exit 1; }\n\
    sleep 5\n\
    docker ps -a\n\
    docker logs --tail 100 dev-$repo_name"

    # Create Docker run script if it doesn't exist
    docker_run_path="$repo_dir/docker_dev_run.sh"
    if [ -f "$docker_run_path" ]; then
        echo "File $docker_run_path already exists. Skipping."
    else
        echo -e "$docker_run_content" > "$docker_run_path"
        chmod 755 "$docker_run_path"
    fi

done < config.txt

echo "Dockerfiles and Docker run scripts generated successfully."
