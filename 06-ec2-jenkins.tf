# Jenkins EC2 Instance Configuration
resource "aws_instance" "jenkins" {
  ami                         = var.jenkins_ami
  instance_type               = var.jenkins_instance_type
  key_name                    = var.jenkins_key_name
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  subnet_id                   = aws_subnet.public_1.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.jenkins_profile.name

  tags = {
    Name = "${var.project_name}-jenkins"
  }
}