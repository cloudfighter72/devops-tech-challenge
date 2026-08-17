resource "aws_security_group" "ecs_sg" {
  name        = "node_ecs_sg"
  description = "Allow traffic from the Application Load Balancer to ECS tasks"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "ecs_sg"
  }
}

# Frontend traffic from the ALB
resource "aws_vpc_security_group_ingress_rule" "ecs_frontend" {
  description                  = "HTTP traffic from ALB to frontend"
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80

  tags = {
    Name = "ECS-Frontend-From-ALB"
  }
}

# Backend traffic from the ALB
resource "aws_vpc_security_group_ingress_rule" "ecs_backend" {
  description                  = "HTTP traffic from ALB to backend"
  security_group_id            = aws_security_group.ecs_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 8080
  ip_protocol                  = "tcp"
  to_port                      = 8080

  tags = {
    Name = "ECS-Backend-From-ALB"
  }
}

# Allow ECS tasks to make outbound connections
resource "aws_vpc_security_group_egress_rule" "sg_egress_all" {
  security_group_id = aws_security_group.ecs_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "sg_egress_all"
  }
}