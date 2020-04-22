output "master_public_ip" {
  value = aws_instance.master.public_ip
}

output "worker_one_public_ip" {
  value = aws_instance.worker_one.public_ip
}
