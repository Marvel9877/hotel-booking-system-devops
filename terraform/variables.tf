variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "mern-ecommerce"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "desired_node_count" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "min_node_count" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "app_namespace" {
  description = "Kubernetes namespace for the application"
[O  type        = string
  default     = "mern-app"
}

# Docker Hub Images
variable "mongodb_image" {
  description = "MongoDB Docker image"
  type        = string
  default     = "mongo:7.0"
}

variable "backend_image" {
  description = "Backend Docker image from Docker Hub"
  type        = string
  default     = "your-dockerhub-username/ecommerce-backend:latest"
}

variable "frontend_image" {
  description = "Frontend Docker image from Docker Hub"
  type        = string
  default     = "your-dockerhub-username/ecommerce-frontend:latest"
}

# Application Configuration
variable "mongodb_database" {
  description = "MongoDB database name"
  type        = string
  default     = "ecommerce"
}

variable "mongodb_root_password" {
  description = "MongoDB root password"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "JWT secret for authentication"
  type        = string
  sensitive   = true
}

variable "backend_replicas" {
  description = "Number of backend pod replicas"
  type        = number
  default     = 2
}

variable "frontend_replicas" {
  description = "Number of frontend pod replicas"
  type        = number
  default     = 2
}
