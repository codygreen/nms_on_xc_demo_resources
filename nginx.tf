resource "random_pet" "server" {
  count  = var.instance_count
  length = 2
}
resource "aws_instance" "nginx" {
  count                       = var.instance_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.egress.id]
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = true
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.nms_profile.name

  user_data = templatefile("${path.module}/user_data/nginx.tpl", {
    hostname           = random_pet.server[count.index].id
    tailscale_auth_key = var.tailscale_auth_key
    region             = var.region
    nginx-repo-crt     = format("%s-nginx-repo-crt-%s", local.owner_name_safe, random_id.id.hex)
    nginx-repo-key     = format("%s-nginx-repo-key-%s", local.owner_name_safe, random_id.id.hex)
    agent-crt          = format("%s-nginx-agent-crt-%s", local.owner_name_safe, random_id.id.hex)
    agent-key          = format("%s-nginx-agent-key-%s", local.owner_name_safe, random_id.id.hex)
    nms_host           = var.nms_host
  })

  tags = {
    Name    = format("%s-nginx-%s", local.owner_name_safe, random_pet.server[count.index].id)
    Owner   = var.owner_email
    Project = format("%s-nms-on-xc", local.owner_name_safe)
  }
}
