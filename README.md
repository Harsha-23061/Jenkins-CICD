# 🌟 Jenkins Pipeline and Scripts Documentation

This repository contains a Jenkins pipeline script and several supporting shell scripts designed to automate the deployment and management of Git repositories on an EC2 instance. The pipeline handles tasks such as checking out code, connecting to the server, cloning repositories, running additional scripts, and managing Docker containers. Additionally, it dynamically creates new Jenkins pipelines for each repository listed in the `repo.txt` file.

---

## 📖 Table of Contents
1. [📜 Jenkins Pipeline Script](#jenkins-pipeline-script)
2. [🔢 Port Number Script](#port-number-script)
3. [📂 Base Script](#base-script)
4. [🐳 Docker Script](#docker-script)
5. [🌐 NGINX Script](#nginx-script)
6. [ℹ️ Additional Information](#additional-information)
7. [✅ Prerequisites](#prerequisites)
8. [⚙️ Setup](#setup)
9. [🚀 Execution](#execution)
10. [🛠️ Troubleshooting](#troubleshooting)

---

## 📜 Jenkins Pipeline Script

The Jenkins pipeline script automates the deployment process by performing the following stages:

### 🛠️ Stages
1. **🔗 Git Checkout**: Checks out code from a specified Git repository.
2. **🔒 Connect to Server and Change Directory**: Connects to an EC2 instance and changes to the specified directory.
3. **📄 Read repo.txt and Clone Git Repositories**: Reads a list of repositories from `repo.txt` and clones them if they don't already exist.
4. **📜 Run Additional Scripts**: Executes additional scripts on the EC2 instance.
5. **📂 List Files After Cloning**: Lists files and displays the contents of `config.txt` after cloning operations.

### 🌍 Environment Variables
- `EC2_INSTANCE`: The address of the EC2 instance.
- `REMOTE_DIR`: The remote directory on the EC2 instance.

---

## 🔢 Port Number Script

The `port_number_script.sh` script generates a `config.txt` file with repository details, including subdomains and port numbers.

### ✨ Features
- ✅ Validates the `repo.txt` file.
- 📝 Creates or appends to the `config.txt` file.
- 🎲 Generates random subdomains and assigns port numbers.

### ▶️ Usage
```bash
./port_number_script.sh
```

---

## 📂 Base Script

The `base_script.sh` script creates deployment scripts for each repository found in the specified directory.

### ✨ Features
- ✅ Validates the base directory.
- 📝 Creates a deployment script for each repository.
- 🔐 Makes the scripts executable.

### ▶️ Usage
```bash
./base_script.sh
```

---

## 🐳 Docker Script

The `docker_script.sh` script generates Dockerfiles and Docker run scripts for each repository listed in `config.txt`.

### ✨ Features
- ✅ Validates the base directory and `config.txt` file.
- 🐳 Creates Dockerfiles and Docker run scripts.
- 🔐 Ensures the scripts are executable.

### ▶️ Usage
```bash
./docker_script.sh
```

---

## 🌐 NGINX Script

The `nginx_script.sh` script updates the NGINX configuration file with proxy settings based on the repositories listed in `config.txt`.

### ✨ Features
- ✅ Validates the NGINX configuration file and `config.txt`.
- 🗂️ Backs up the original NGINX configuration file.
- 🌐 Updates the NGINX configuration with new proxy settings.
- 🔄 Commits and pushes changes to the Git repository if changes are made.

### ▶️ Usage
```bash
./nginx_script.sh
```

---

## ℹ️ Additional Information

### 🛠️ Pipeline Customization for Different Environments and Docker Images
This pipeline is designed to work with standard Docker images such as `python:3.12` or `node:20`. If your application requires a different Docker image or environment setup, customize the pipeline accordingly.

#### Example Customizations:

**⚙️ Backend Application using Python:**
```Dockerfile
FROM python:3.12
```
- Ensure the pipeline script includes steps to install Python dependencies and run the application.

**🖼️ Frontend Application using Node.js:**
```Dockerfile
FROM node:20
```
- Ensure the pipeline script includes steps to install Node.js dependencies and build the application.

### 🔄 Dynamic Pipeline Creation
Once the Jenkins pipeline executes successfully, it will automatically create a new pipeline for each repository listed in the `repo.txt` file. This new pipeline will be configured to handle the specific requirements of the repository.

#### Example of a New Pipeline:
```groovy
node {
    stage('Git Checkout') {
        // 🔗 Checkout the code for the new repository
        git branch: 'dev-01', credentialsId: 'a1b2c3d4-e5f6-7890-1234-567890abcdef', url: 'https://github.com/octocat/${repo}.git'
    }
    stage('Deploy to Dev-01') {
        sshagent(['b0c1d2e3-f4g5-67h8-90i1-j2k3l4m5n6o7']) {
            // 🚀 Deploy the code by running a shell script on the EC2 instance
            sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_INSTANCE} 'cd /home/ubuntu/bitbucket/dev && bash dev-${repo}.sh'"
        }
    }
    stage('Sending a Mail') {
        // ✉️ Send an email notification after deployment
        mail bcc: '', body: 'Deployment is done, please check the changes', cc: '', from: '', replyTo: '', subject: 'Stage deployment for dev-${repo}', to: 'randomuser@example.com'
    }
}
```

---

## ✅ Prerequisites

- 🖥️ Jenkins with the necessary plugins installed.
- 🛡️ An EC2 instance with SSH access.
- 🗂️ Git repository with the necessary credentials.
- 🐳 Docker installed on the EC2 instance.
- 🌐 NGINX installed on the EC2 instance.

---

## ⚙️ Setup

1. **📜 Jenkins Pipeline**: Copy the Jenkins pipeline script into your Jenkins pipeline configuration.
2. **📝 Shell Scripts**: Place the shell scripts in the appropriate directory on your EC2 instance and ensure they are executable.
3. **🌍 Environment Variables**: Set the necessary environment variables in the Jenkins pipeline script.

---

## 🚀 Execution

- ▶️ Trigger the Jenkins pipeline manually or set up a webhook to trigger it automatically on code changes.
- 🖥️ Monitor the pipeline execution in the Jenkins interface.

---

## 🛠️ Troubleshooting

- ✅ Ensure all required environment variables are set correctly.
- 🔍 Check the Jenkins console output for any errors.
- 🌐 Verify that the EC2 instance is accessible and that the necessary directories and files exist.
