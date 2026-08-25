variable "aws_region" {
  description = "AWS region where resources will be created."
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name used as a prefix for resource names and tags."
  type        = string
  default     = "node-ecs"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1."
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2."
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone_1" {
  description = "Availability zone for public subnet 1."
  type        = string
  default     = "us-east-2a"
}

variable "availability_zone_2" {
  description = "Availability zone for public subnet 2."
  type        = string
  default     = "us-east-2b"
}

variable "jenkins_ami" {
  description = "AMI ID used by the Jenkins EC2 instance."
  type        = string
  default     = "ami-0e5497a77ef21b5ac"
}

variable "jenkins_instance_type" {
  description = "EC2 instance type for Jenkins."
  type        = string
  default     = "t3.micro"
}

variable "jenkins_key_name" {
  description = "Existing EC2 key pair name for the Jenkins instance."
  type        = string
  default     = "ec2-lab-app"
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  type        = string
  default     = "node-cluster"
}

variable "backend_cpu" {
  description = "CPU units allocated to the backend ECS task."
  type        = number
  default     = 512
}

variable "backend_memory" {
  description = "Memory in MiB allocated to the backend ECS task."
  type        = number
  default     = 1024
}

variable "frontend_cpu" {
  description = "CPU units allocated to the frontend ECS task."
  type        = number
  default     = 512
}

variable "frontend_memory" {
  description = "Memory in MiB allocated to the frontend ECS task."
  type        = number
  default     = 1024
}

variable "ecs_desired_count" {
  description = "Initial desired number of ECS tasks for each service."
  type        = number
  default     = 1
}

variable "ecs_min_capacity" {
  description = "Minimum ECS task count for autoscaling."
  type        = number
  default     = 1
}

variable "ecs_max_capacity" {
  description = "Maximum ECS task count for autoscaling."
  type        = number
  default     = 4
}

variable "autoscaling_target_cpu" {
  description = "Target average CPU utilization percentage for ECS autoscaling."
  type        = number
  default     = 50
}