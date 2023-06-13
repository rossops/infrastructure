aws_region = "us-east-1"

cluster_name = "eks-prod"

cluster_subnets = [
  "subnet-xxxxxxxx",
  "subnet-yyyyyyyy",
  "subnet-zzzzzzzz"
]

eks_managed_node_group_defaults = {
  ami_release_version = "1.23.13-20221222"
  ami_type            = "AL2_x86_64"
  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 400
        volume_type           = "gp3"
      }
    }
  }
  create_launch_template = true
  desired_size           = 17
  ebs_optimized          = true
  instance_types         = ["c6i.4xlarge"]
  key_name               = "DownDetective"
  max_size               = 30
  min_size               = 2
  timeouts = {
    create = "60m"
    update = "360m"
    delete = "60m"
  }
}

eks_managed_node_groups = {
  prod-nix01 = {
    subnet_ids = ["subnet-xxxxxxx"]
  }
  prod-nix02 = {
    subnet_ids = ["subnet-xxxxxxxx"]
  }
  prod-nix03 = {
    subnet_ids = ["subnet-xxxxxxxx"]
  }
  prod-win01 = {
    ami_release_version = "1.23-2023.01.11"
    ami_type            = "WINDOWS_CORE_2019_x86_64"
    create_iam_role     = false
    desired_size        = 2
    iam_role_arn        = "arn:aws:iam::xxxxxxxxxxx:role/eks-prod-windowsxxxxxxxxxx"
    platform            = "windows"
    subnet_ids = [
      "subnet-558d3209",
      "subnet-8904b6ee",
      "subnet-688fcd22"
    ]
    taints = [
      {
        key    = "os"
        value  = "windows"
        effect = "NO_SCHEDULE"
      }
    ]
  }
}

environment = "prod"

iam_role_name = "eks-prodxxxxxxxxxxx"

map_roles = [
  {
    rolearn  = "arn:aws:iam::xxxxxxxxxxxx:role/eksadmin"
    username = "eksadmin"
    groups   = ["system:masters"]
  }
]

# dd prod vpc
vpc_id = "vpc-xxxxxx"
