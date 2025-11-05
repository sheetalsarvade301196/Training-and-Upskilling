#!/bin/bash
# =====================================================================
# EC2 Linux Bootstrap Script (CloudOps Edition)
# Installs and verifies essential tools for AWS, DevOps, and CloudOps
# =====================================================================

set -e  # Exit immediately on error
LOGFILE="/var/log/ec2_setup.log"

exec 2>&1

echo "-------------------------------------------------------------"
echo "🚀 Starting EC2 setup on $(hostname) at $(date)"
echo "-------------------------------------------------------------"

# Detect OS
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
else
  OS=$(uname -s)
fi

echo "Detected OS: $OS"

# Update system
echo "📦 Updating system packages..."
case "$OS" in
  amzn|rhel|centos)
    sudo yum update -y
    ;;
  ubuntu|debian)
    sudo apt update -y && sudo apt upgrade -y
    ;;
  *)
    echo "⚠️ Unsupported OS: $OS. Exiting."
    exit 1
    ;;
esac

# Install essential utilities
echo "🧰 Installing essential utilities..."
case "$OS" in
  amzn|rhel|centos)
    sudo yum install -y git wget curl unzip vim net-tools telnet htop lsof jq tree zip unzip bash-completion nmap python3-pip
    ;;
  ubuntu|debian)
    sudo apt install -y git wget curl unzip vim net-tools telnet htop lsof jq tree zip unzip bash-completion nmap python3-pip
    ;;
esac

# Enable bash completion
if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

# Install AWS CLI v2
if ! command -v aws &> /dev/null; then
  echo "☁️ Installing AWS CLI v2..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  rm -rf aws awscliv2.zip
else
  echo "✅ AWS CLI already installed."
fi

# Install Docker
if ! command -v docker &> /dev/null; then
  echo "🐳 Installing Docker..."
  case "$OS" in
    amzn|rhel|centos)
      sudo yum install -y docker
      ;;
    ubuntu|debian)
      sudo apt install -y docker.io
      ;;
  esac
  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -aG docker $USER
  echo "✅ Docker installed and running."
else
  echo "✅ Docker already installed."
fi

# Install Terraform
if ! command -v terraform &> /dev/null; then
  echo "🏗️ Installing Terraform..."
  TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)
  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
  sudo mv terraform /usr/local/bin/
  rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip
  echo "✅ Terraform ${TERRAFORM_VERSION} installed."
else
  echo "✅ Terraform already installed."
fi

# Install Ansible
if ! command -v ansible &> /dev/null; then
  echo "🔧 Installing Ansible..."
  sudo pip3 install ansible
  echo "✅ Ansible installed."
else
  echo "✅ Ansible already installed."
fi

# Install AWS Session Manager plugin
if ! command -v session-manager-plugin &> /dev/null; then
  echo "🔐 Installing AWS Session Manager plugin..."
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
  if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    sudo apt install ./session-manager-plugin.rpm -y
  else
    sudo yum install -y session-manager-plugin.rpm
  fi
  rm -f session-manager-plugin.rpm
else
  echo "✅ Session Manager plugin already installed."
fi

# Cleanup
echo "🧹 Cleaning up unnecessary packages..."
sudo apt-get autoremove -y 2>/dev/null || sudo yum autoremove -y 2>/dev/null

# ---------------------------------------------------------------------
# ✅ POST-INSTALL VALIDATION
# ---------------------------------------------------------------------
echo
echo "-------------------------------------------------------------"
echo "🔎 Post-Install Validation Summary"
echo "-------------------------------------------------------------"

check_cmd() {
  if command -v $1 &> /dev/null; then
    echo "✅ $1 is installed → Version: $($1 --version | head -n 1)"
  else
    echo "❌ $1 not found!"
  fi
}

check_cmd aws
check_cmd docker
check_cmd terraform
check_cmd ansible
check_cmd jq
check_cmd nmap
check_cmd htop
check_cmd git
check_cmd vim

echo
echo "-------------------------------------------------------------"
echo "🎉 EC2 setup completed successfully on $(hostname)"
echo "📘 Log file: $LOGFILE"
echo "-------------------------------------------------------------"
echo "🔁 Reminder: Log out and log in again for Docker group access."
echo "-------------------------------------------------------------"
