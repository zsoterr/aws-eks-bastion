# aws-eks-bastion
Create a simple eks cluster with bastion host support on AWS

Steps:
1. Edit the variables.tf and terraform.tfvars under bastion_host directory and update the names and values of the variables.
2. Set the kubernetes verion in main_eks.tf (The current version is 1.20)
3. Run terraform commands to deploy eks cluster.

The deployment will create an eks cluster and update the config map (aws_auth) in kube-system namespace with instance role name with admin permission.

4. If the cluster is ready, run the bastion host deployment,too.
Navigate to bastion_host directory and:
- update the names and values of the variables in variables.tf and terraform.tfvars
- update the instance number (if you want) in ec2.tf (The current min_size is 1)
5. Run terraform commands to deploy bastion host(s).
6. Download the private key from secrets manager, and set the right permission on the file (chmod 0400) and connect to bastion host and use kubectl command to reach the cluster.
