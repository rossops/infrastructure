# EKS Implementation

## Existing clusters

- [eks-infratest](https://dashboard-eks-infratest.ddlocal.com)
- [eks-dev](https://dashboard-eks-dev.ddlocal.com)
- [eks-stage](https://dashboard-eks-stage.ddlocal.com)
- [eks-prod](https://dashboard-eks-prod.downdetective.com)

## Design basics

The goal is to put all the cluster config into code.  This makes it easier to create new clusters and see how things are configured

- infrastructure and basic cluster permissions handled by Terraform: [infra/README.md](infra/README.md)
- Helm charts handled by Helmfile: [helm-releases/README.md](helm-releases/README.md)
- All pod deployments should configure `imagePullSecrets` or use an image not from the Docker Hub registry to avoid throttling issues, <https://docs.docker.com/docker-hub/download-rate-limit/>

## Windows nodes

To deploy a Windows pod, you must do the following:

- Have a container based on Windows 2019
- Setup your application to send logs directly to Sumologic.  The process we use to collect logs on Linux nodes does not yet work for windows nodes
- Add this nodeSelector to your pod yaml: `kubernetes.io/os: windows`
- Add this toleration to your pod yaml:

```yaml
tolerations:
- key: "node.kubernetes.io/os"
  operator: "Equal"
  value: "windows"
  effect: "NoSchedule"
- key: "os"
  operator: "Equal"
  value: "windows"
  effect: "NoSchedule"
```

Caveat: Windows nodes are not enabled on all clusters yet.

More details about Windows container support in k8s: <https://kubernetes.io/docs/setup/production-environment/windows/intro-windows-in-kubernetes/>

## Cluster access

### CLI

kubectl can be configured to access a cluster with the following command:

```sh
aws eks update-kubeconfig --region us-east-1 --name [cluster_name] --role-arn "arn:aws:iam::xxxxxxxxxxxxx:role/eksadmin"
```

:brain: Use the following helper script in zsh or bash:

```bash
(
  CLUSTERS=('eks-dev' 'eks-stage' 'eks-prod')
  ROLE="arn:aws:iam::xxxxxxxxxxxxxxx:role/eksdevs"

  for cluster in "${CLUSTERS[@]}"
  do
    echo "updating kubeconfig for $cluster"
    aws eks update-kubeconfig \
      --role-arn $ROLE \
      --region us-east-1 \
      --name $cluster \
      --alias $cluster
  done

  echo "Updates complete"
  echo
  kubectl config get-contexts
)
```

If you are a developer, your access is via IAM Role `arn:aws:iam::xxxxxxxxxxxxxx:role/eksdevs`

### Dashboard

kubernetes-dashboard can be accessed at <http://dashboard-CLUSTERNAME.ddlocal.com>.  Access is read-only

## Monitoring

Currently kube-dashboard is used for metrics. Console logs can be found on the ELK server. 

## Pod Auto Scaling

Only one of these can be used at a time:

- The K8S Horizontal Pod Autoscaler can be used for simple scaling by cpu or memory usage
- [KEDA](https://keda.sh/) can be used for more complicated needs.
  - Available scalers: <https://keda.sh/docs/2.4/scalers/>
  - If you are using an AWS trigger, you must set `metadata.identityOwner=operator`

## Pod IAM permissions

Pods that need AWS permissions should use [IAM Roles for Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)

How?

- create an IAM role with the needed permissions: <https://docs.aws.amazon.com/eks/latest/userguide/create-service-account-iam-policy-and-role.html>
- add the IAM role as an annotation to the service account the Pod will use: <https://docs.aws.amazon.com/eks/latest/userguide/specify-service-account-role.html>
- minimum SDK needed: <https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts-minimum-sdk.html>

Example with cluster-autoscaler:

- IAM Role: [infra/irsa-autoscaler.tf](infra/irsa-autoscaler.tf)
- Service Annotation: [helm-charts/subfiles/cluster-autoscaler.yaml](helm-charts/subfiles/cluster-autoscaler.yaml)

Example with r2deploy, using kube-webservice chart

- IAM Role: [../../services/r2deploy/infra/terraform/irsa.tf](../../services/r2deploy/infra/terraform/irsa.tf)
- Service Annotation: [../../services/r2deploy/infra/helm-values/values.stage.yaml](../../services/r2deploy/infra/helm-values/values.stage.yaml)

## EKS upgrade process

Follow the upgrade guidance in the EKS documentation: <https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html>

1. Disable Descheduler: `./descheduler-onoff.sh -c CLUSTERNAME -a off` or [Descheduler On/Off](http://build.downdetective.com/viewType.html?buildTypeId=DevOps_Eks_DeschedulerOnOff)
2. Perform the manual pre-upgrade steps from the EKS documentation (if there are any)
3. Apply Terraform changes to update the cluster, nodes, and addons
4. Update Cluster Autoscaler and nodelocal-dnscache via [Deploy Helmfile Changes](http://build.downdetective.com/viewType.html?buildTypeId=DevOps_Eks_DeployHelmfileChanges)
5. Perform the manual post-upgrade steps from the EKS documentation (if there are any)
6. Re-enable Descheduler: `./descheduler-onoff.sh -c CLUSTERNAME -a on` or [Descheduler On/Off](http://build.downdetective.com/viewType.html?buildTypeId=DevOps_Eks_DeschedulerOnOff)
