# NMS on XC Demo Resources

Deploy NGINX Plus resources into AWS to demo NMS on XC

> Note: NMS on XC is in early preview so not all resources will be publicly available.

> Note: This deployment leverages [Tailscale](https://tailscale.com/) to connect into the EC2 instances.

This Terraform example will deploy an NGINX Plus instances with the NGINX Agent in AWS and register the instance with NMS.

![Lab diagram](./NMS_on_XC.png)

## Deployment

> Note: You will need to save your *nginx-repo.crt*, *nginx-repo.key*, agent.crt and agent.key files in the base folder of this project.

Run the following Terraform commands to deploy the environment:

```bash
terraform init
terraform apply -auto-approve
```
