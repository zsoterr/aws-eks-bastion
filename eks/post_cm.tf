resource "null_resource" "cm_aws_auth_update" {
  provisioner "local-exec" {
    command     = <<EOT
  status=`aws eks describe-cluster --name $CLUSTER | jq .cluster.status |cut -f2 -d'"'`
  echo "The current STATUS of the cluster : $status -before we will move forward to NEXT steps."
  while [ $status != "ACTIVE" ]; do if (( SECONDS > 180 )); then echo "Giving up after 180seconds..."&&exit 1; fi; echo "Sleep for 10 seconds..."&& sleep 10&&status=`aws eks describe-cluster --name $CLUSTER | jq .cluster.status |cut -f2 -d'"'` ;done
  echo "The cluster STATUS now: $status -after waiting for (max.) 180 seconds."
  aws eks --region "$REGION" update-kubeconfig --name "$CLUSTER"
  kubectl get nodes
  ROLE="    - rolearn: arn:aws:iam::"$ID":role/"$ROLENAME"\n      username: system:admin\n      groups:\n        - system:masters"
  kubectl get -n kube-system configmap/aws-auth -o yaml | awk "/mapRoles: \|/{print;print \"$ROLE\";next}1" > aws-auth-patch.yml
  kubectl patch configmap/aws-auth -n kube-system --patch "$(cat aws-auth-patch.yml)"
  EOT
    interpreter = ["/bin/bash", "-c"]
    environment = {
      ID       = var.account_id
      CLUSTER  = var.cluster_name
      ROLENAME = var.role_name
      REGION = var.aws_region
    }
  }
  depends_on = [
    module.eks.cluster_endpoint, module.eks.node_security_group_id
  ]
}