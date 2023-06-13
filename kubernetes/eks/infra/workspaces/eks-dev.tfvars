aws_region = "us-east-1"

cluster_name = "eks-dev"

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
  desired_size           = 10
  ebs_optimized          = true
  instance_types         = ["t3.2xlarge"]
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
  dev-nix01 = {
    subnet_ids = ["subnet-xxxxxxxx"]
  }
  dev-nix02 = {
    subnet_ids = ["subnet-yyyyyyyy"]
  }
  dev-nix03 = {
    subnet_ids = ["subnet-zzzzzzzz"]
  }
  dev-win01 = {
    ami_release_version = "1.23-2023.01.11"
    ami_type            = "WINDOWS_CORE_2019_x86_64"
    create_iam_role     = false
    desired_size        = 2
    iam_role_arn        = "arn:aws:iam::xxxxxxxxx:role/eks-dev-windowsxxxxxxxxxxxxxx"
    platform            = "windows"
    subnet_ids = [
      "subnet-810949cb",
      "subnet-fa60d09d",
      "subnet-6615a73a"
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
environment = "dev"

iam_role_name = "eks-devxxxxxxxxxxxxxxxx"

map_roles = [
  {
    rolearn  = "arn:aws:iam::xxxxxxxxx:role/eksadmin"
    username = "eksadmin"
    groups   = ["system:masters"]
  }
]

# dd dev vpc
vpc_id = "vpc-xxxxxx"
