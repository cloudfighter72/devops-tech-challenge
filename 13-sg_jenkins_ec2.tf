resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow inbound traffic for Jenkins server"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "jenkins-sg"
  }
}

# Ingress Rule for SSH (Port 22)
resource "aws_vpc_security_group_ingress_rule" "jenkins_ssh" {
  description       = "Allow SSH access"
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    Name = "jenkins-ssh"
  }
}

# Ingress Rule for Jenkins Web UI (Port 8080)
resource "aws_vpc_security_group_ingress_rule" "jenkins_ui" {
  description       = "Allow Jenkins UI access"
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080

  tags = {
    Name = "jenkins-ui"
  }
}

########## Egress Rules ##########

resource "aws_vpc_security_group_egress_rule" "jenkins_egress_allow_all" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # Allows all ports and protocols

  tags = {
    Name = "jenkins-egress-allow-all"
  }
}