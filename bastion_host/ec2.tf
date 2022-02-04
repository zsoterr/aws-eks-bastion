provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      owner       = "YOURNAME"
      environment = "bastion"
      Name        = "YOURNAME-bastion"
    }
  }
}

resource "aws_security_group" "allow_to_bastion" {
  name        = "allow_to_bastion"
  description = "Allow connections to bastion host, inbound traffic"
  vpc_id      = var.vpc

  ingress {
    description = "Allow SSH connection from whitelisted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.sg_bastion_ing_source]
  }

//remove icmp rule in production!:
  ingress {
    description = "Allow all ICMP ipv4 traffic from whitelisted IP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.sg_bastion_ing_source]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 }


resource "null_resource" "create_ssh_keys" {
  triggers = {
    invokes_me_everytime = uuid()
    KEYPAIR              = var.keypair_name
    SECRET               = var.secret_private_key_name
  }

  provisioner "local-exec" {
    command     = <<EOT
    mykey=`aws ec2 create-key-pair --key-name $KEYPAIR --query 'KeyMaterial' --output text`
    aws secretsmanager create-secret --name $SECRET --secret-string "$mykey"
  EOT
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KEYPAIR = var.keypair_name
      SECRET  = var.secret_private_key_name
    }
  }

  depends_on = [
  ]

  provisioner "local-exec" {
    when        = destroy
    command     = <<EOT
       aws secretsmanager delete-secret --secret-id "$SECRET" --force-delete-without-recovery --region eu-central-1
       aws ec2 delete-key-pair --key-name $KEYPAIR
   EOT
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KEYPAIR = self.triggers.KEYPAIR
      SECRET  = self.triggers.SECRET
    }
  }
}


data "template_file" "user_data" {
  template = file("bastion_user_data.sh.tpl")
  vars = {
    cluster-eks = "${var.cluster_name}"
  }
}

module "bastion-asg" {
  source                       = "terraform-aws-modules/autoscaling/aws"
  version                      = "~> 3.7"
  name                         = "${var.bastion_name}-bastion"
  lc_name                      = "${var.bastion_name}-bastion-launchconf"
  image_id                     = data.aws_ami.pub_centos.id
  instance_type                = var.instance_type[0]
  security_groups              = [aws_security_group.allow_to_bastion.id]
  associate_public_ip_address  = true
  recreate_asg_when_lc_changes = true
  iam_instance_profile         = aws_iam_instance_profile.bastion_instance_role.name
  root_block_device = [
    {
      volume_size           = "10"
      volume_type           = "gp2"
      delete_on_termination = true
    },
  ]

  asg_name                  = "${var.bastion_name}-bastion"
  vpc_zone_identifier       = var.subnets_pub
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  key_name                  = var.keypair_name
  user_data                 = data.template_file.user_data.rendered
}
