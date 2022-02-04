output "eks_cluster_arn" {
  value       = module.eks.cluster_arn
  description = "arn of eks cluster."
}

output "eks_cluster_ca" {
  value       = module.eks.cluster_certificate_authority_data
  description = "certificate data required to communicate with the cluster"
}

output "cluster_endpoint" {
  description = "Endpoint of EKS cluster."
  value       = module.eks.cluster_endpoint
}

/* 17.22 version doesn't support this
output "eks_cluster_status" {
  value       = module.eks.cluster_status
  description = "Status of the created cluster"
}
*/