# infrastructure

### devops-sample-app
A very basic docker based application that devs can use to learn how helm, Terraform and Docker work. This will create AWS resources such as an RDS Database and Redis Elasticache instance that will need to be deleted. 

### kubernetes (infra/)
This will create a kube cluster with all the required modules and aws resources. To create a new cluster, define a new tfvars in infra/workspaces. When provisioning this cluster in spacelift, simply add the TF_CLI_ARGS variable and set it to -var-file="workspaces/__yourfile__.tfvars".
