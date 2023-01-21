# NMS on XC Demo Resources

Deploy NGINX Plus resources into AWS to demo NMS on XC

> Note: NMS on XC is in early preview so not all resources will be publicly available.

> Note: This deployment leverages [Tailscale](https://tailscale.com/) to connect into the EC2 instances.

This Terraform example will deploy multiple NGINX Plus instances with the NGINX Agent in AWS and register the instance with NMS.

![Lab diagram](./NMS_on_XC.png)

## Deployment

> Note: You will need to save your *nginx-repo.crt*, *nginx-repo.key*, agent.crt and agent.key files in the base folder of this project.

Run the following Terraform commands to deploy the environment:

```bash
terraform init
terraform apply -auto-approve
```

## Terraform Variables

| Variable  | Description  |
|---|---|
| instance_count  | number of NGINX EC2 instances created  |
| instance_type  |  EC2 instance type |
| key_name | EC2 Key Pair name  |
| nms_host  | NGINX Management Suite Host Name (FQDN)  |
| owner_name  | Name of user deploying Terraform - for AWS resource tagging  |
| owner_email | Email of user deploying Terraform - for AWS resource tagging |
| region  | AWS region resources will be deployed into  |
| tailscale_auth_key | Tailscale Auth key to authenticate EC2 instances to your tailscale environment |
