output "jenkins_master_public_ip" {
  value = aws_instance.inst_jenks_master.public_ip
}

output "jenkins_worker_private_ip" {
  value = aws_instance.inst_jenks_worker.private_ip
}