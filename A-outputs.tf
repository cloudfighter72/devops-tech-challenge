# Output ECR Repository URLs
output "backend_repository_url" {
  value       = aws_ecr_repository.backend.repository_url
  description = "The URL of the backend ECR repository"
}

output "frontend_repository_url" {
  value       = aws_ecr_repository.frontend.repository_url
  description = "The URL of the frontend ECR repository"
}

# Output the Jenkins server public IP
output "jenkins_public_ip" {
  value       = aws_instance.jenkins.public_ip
  description = "Public IP address of the Jenkins EC2 instance"
}