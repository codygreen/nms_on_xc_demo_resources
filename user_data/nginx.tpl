#cloud-config
---
update_hostname: ${hostname}
package_update: true
package_upgrade: true
apt:
  sources:
    tailscale.list:
      source: deb https://pkgs.tailscale.com/stable/ubuntu focal main
      keyid: 2596A99EAAB33821893C0A79458CA832957F5868
packages: 
  - tailscale
  - awscli
  - apt-transport-https
  - lsb-release
  - ca-certificates 
  - wget 
  - gnupg2
  - ubuntu-keyring
runcmd:
  - [tailscale, up, -authkey, ${tailscale_auth_key}, -hostname, ${hostname}]
  - hostnamectl set-hostname ${hostname}
  - mkdir /etc/ssl/nginx
  # install our certs and keys
  - aws secretsmanager get-secret-value --secret-id ${nginx-repo-crt} --region ${region} --query 'SecretString' --output text > /etc/ssl/nginx/nginx-repo.crt
  - aws secretsmanager get-secret-value --secret-id ${nginx-repo-key} --region ${region} --query 'SecretString' --output text > /etc/ssl/nginx/nginx-repo.key
  - aws secretsmanager get-secret-value --secret-id ${agent-crt} --region ${region} --query 'SecretString' --output text > /etc/ssl/nginx/agent.crt
  - aws secretsmanager get-secret-value --secret-id ${agent-key} --region ${region} --query 'SecretString' --output text > /etc/ssl/nginx/agent.key
  # install NGINX Plus
  - wget -qO - https://cs.nginx.com/static/keys/nginx_signing.key | gpg --dearmor | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
  - wget -qO - https://cs.nginx.com/static/keys/app-protect-security-updates.key | gpg --dearmor | sudo tee /usr/share/keyrings/app-protect-security-updates.gpg >/dev/null
  - printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | sudo tee /etc/apt/sources.list.d/nginx-plus.list
  - sudo wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx
  - sudo apt-get update
  - sudo apt-get install -y nginx-plus
  - systemctl start nginx
  # install NGINX Agent
  - curl --cert /etc/ssl/nginx/agent.crt --key /etc/ssl/nginx/agent.key https://${nms_host}/install/nginx-agent > install.sh
  - sudo sh ./install.sh --skip-verify false
  # Configure NGINX Agent
  - snap install yq
  # Note: snap sandboxes yq, so we need to copy the file out, modify, then copy back in
  - sudo cp /etc/nginx-agent/nginx-agent.conf /home/ubuntu/
  - sudo yq -i '.tls.skip_verify = false' /home/ubuntu/nginx-agent.conf
  - sudo yq -i '.tls.cert = "/etc/ssl/nginx/agent.crt"' /home/ubuntu/nginx-agent.conf
  - sudo yq -i '.tls.key = "/etc/ssl/nginx/agent.key"' /home/ubuntu/nginx-agent.conf
  - sudo cp /home/ubuntu/nginx-agent.conf /etc/nginx-agent/nginx-agent.conf
  - sudo systemctl start nginx-agent

