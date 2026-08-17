# Jenkins EC2 Instance Configuration
resource "aws_instance" "jenkins" {
  ami                         = "ami-0e5497a77ef21b5ac"
  instance_type               = "t3.micro"
  key_name                    = "ec2-lab-app"
  vpc_security_group_ids      = [aws_security_group.jenkins_sg.id]
  subnet_id                   = aws_subnet.public_1.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.jenkins_profile.name

  tags = {
    Name = "jenkins"
  }
}