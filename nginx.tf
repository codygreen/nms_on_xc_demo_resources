resource "aws_instance" "nginx" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.egress.id]
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = false
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.nms_profile.name

  user_data = templatefile("${path.module}/user_data/nginx.tpl", {
    hostname           = "nginx"
    tailscale_auth_key = var.tailscale_auth_key
    region             = var.region
    nginx-repo-crt     = format("%s-nginx-repo-crt-%s", local.owner_name_safe, random_id.id.hex)
    nginx-repo-key     = format("%s-nginx-repo-key-%s", local.owner_name_safe, random_id.id.hex)
  })

  tags = {
    Name    = format("%s-nginx", local.owner_name_safe)
    Owner   = var.owner_email
    Project = format("%s-nms-on-xc", local.owner_name_safe)
  }
}
