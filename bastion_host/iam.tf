resource "aws_iam_role" "instance_role" {
  name = "${var.cluster_name}-bastion-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "instance_role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.instance_role.name
}

resource "aws_iam_role_policy_attachment" "instance_role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.instance_role.name
}

resource "aws_iam_role_policy_attachment" "instance_role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.instance_role.name
}

resource "aws_iam_instance_profile" "bastion_instance_role" {
  name = "${var.cluster_name}-eks-bastion_instance_role"
  role = aws_iam_role.instance_role.name
}