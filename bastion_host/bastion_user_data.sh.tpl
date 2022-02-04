#!/bin/bash
  sudo yum update -y
  # Update python
  sudo yum install python37 -y
  # Install pip
  curl -O https://bootstrap.pypa.io/get-pip.py
  python3 get-pip.py --user
  # Upgrade aws cli
  pip3 install --upgrade --user awscli
  ## Install kubectl
  curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
  echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
  # Install aws-iam-authenticator
  curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator
  chmod +x ./aws-iam-authenticator
  mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
  echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
  # Install eksctl
  # curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
  # sudo mv /tmp/eksctl /usr/local/bin
  sudo yum install -y jq
  CLUSTER=${cluster-eks}
  runuser -l ec2-user bash -c "aws eks --region eu-central-1 update-kubeconfig --name $CLUSTER"
