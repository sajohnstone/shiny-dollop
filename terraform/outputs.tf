output "postgres-password" {
  value = random_string.postgres-password.result
}

output "postgres-hostname" {
  value = aws_db_instance.postgres-test-instance.address
}
