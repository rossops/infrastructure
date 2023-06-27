.DEFAULT_GOAL := help

.PHONY: all
all: build_image login_ecr docker_tag docker_push_ecr update_ecs

.PHONY: help
help: ## Print build target help
        @awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

APP_NAME = devops-sample-app
AWS_PROFILE = my_profile
AWS_REGION = us-east-1
AWS_ACCOUNT_ID = 222222222222222
AWS_SERVER = $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

AWS_ECS_CLUSTER = my_cluster
AWS_ECS_SERVICE = my_ecs_service
AWS_ECS_TASK_DEFINITION = my_ecs_task_def
AWS_ECS_TASK_REVISION = my_task_rev

.PHONY: build_image
build_image: ## Builds docker image
  docker buildx build -t devops-sample-app .


.PHONY: login_ecr
login_ecr: ## Login to ECR
  bash -c 'aws-vault exec $(AWS_PROFILE) -- aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_SERVER)'

.PHONY: docker_tag
docker_tag: ## Tag docker image with short sha
  $(eval REV=$(shell git rev-parse HEAD | cut -c1-7))
  AWS_REGION = $(AWS_REGION)
  docker tag $(APP_NAME):latest $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(APP_NAME):latest
  docker tag $(APP_NAME):latest $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(APP_NAME):$(REV)

.PHONY: docker_push_ecr
docker_push_ecr: ## Push image up to exr
  $(eval REV=$(shell git rev-parse HEAD | cut -c1-7))
  AWS_REGION = $(AWS_REGION)
  docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(APP_NAME):latest
  docker push $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(APP_NAME):$(REV)   

.PHONY: update_ecs
update_ecs: ## Update ECS service with new task revision
  aws ecs update-service --cluster $(AWS_ECS_CLUSTER) --service $(AWS_ECS_SERVICE) --task-definition $(AWS_ECS_TASK_DEFINITION):$(AWS_ECS_TASK_REVISION)")