module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "magdalena-cluster-prd"
  kubernetes_version = "1.33"

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = "vpc-07b30a0ecdef8731b"
  subnet_ids               = ["subnet-0b3308d22dcf9f849", "subnet-0103c2d2a71a03047"]
  control_plane_subnet_ids = ["subnet-0b3308d22dcf9f849", "subnet-0103c2d2a71a03047"]

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    worker-nodes = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3a.medium"]
      disk_size = 50
      min_size     = 1
      max_size     = 1
      desired_size = 1
    }
  }

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}