resource "aws_secretsmanager_secret" "nginx-repo-crt" {
  name = format("%s-nginx-repo-crt-%s", local.owner_name_safe, random_id.id.hex)
}

resource "aws_secretsmanager_secret" "nginx-repo-key" {
  name = format("%s-nginx-repo-key-%s", local.owner_name_safe, random_id.id.hex)
}

resource "aws_secretsmanager_secret_version" "nginx-repo-crt" {
  secret_id     = aws_secretsmanager_secret.nginx-repo-crt.id
  secret_string = file("${path.module}/nginx-repo.crt")
}
resource "aws_secretsmanager_secret_version" "nginx-repo-key" {
  secret_id     = aws_secretsmanager_secret.nginx-repo-key.id
  secret_string = file("${path.module}/nginx-repo.key")
}

resource "aws_secretsmanager_secret" "nginx-agent-crt" {
  name = format("%s-nginx-agent-crt-%s", local.owner_name_safe, random_id.id.hex)
}

resource "aws_secretsmanager_secret" "nginx-agent-key" {
  name = format("%s-nginx-agent-key-%s", local.owner_name_safe, random_id.id.hex)
}

resource "aws_secretsmanager_secret_version" "nginx-agent-crt" {
  secret_id     = aws_secretsmanager_secret.nginx-agent-crt.id
  secret_string = file("${path.module}/agent.crt")
}
resource "aws_secretsmanager_secret_version" "nginx-agent-key" {
  secret_id     = aws_secretsmanager_secret.nginx-agent-key.id
  secret_string = file("${path.module}/agent.key")
}
