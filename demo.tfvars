general = {
  environment = "dev"
  project     = "myproj"
  region      = "eu-central-1"
}

infrastructure = {
  type         = "FARGATE"
  fargate_spot = true
  ec2_types    = ["c7i-flex.large"]
}

services = {
  frontend = {
    name          = "frontend"
    img           = "649636402385.dkr.ecr.us-east-1.amazonaws.com/frontend:v2"
    desired_count = 2
    alb_path      = "/*"
    target_port   = 3000
    spot_percent  =  40 
    requirements = {
      cpu    = 256
      memory = 512
    }

    deploy = {
      enabled   = true
      strategy  = "BLUE_GREEN"
      bake_time = 1
    }

    autoscaling = {
      enabled            = false
      min                = 1 
      max                = 10
      metric             = "CPUUtilization"
      metric_target      = 70
      scale_in_cooldown  = 20
      scale_out_cooldown = 20
    }
  }
  api = {
    name          = "api"
    img           = "649636402385.dkr.ecr.us-east-1.amazonaws.com/backend:v4"
    desired_count = 1
    alb_path      = "/api/*"
    health_check  = "/api/health"
    target_port   = 3001
    requirements = {
      cpu    = 256
      memory = 512
    }

    deploy = {
      enabled   = true
      strategy  = "BLUE_GREEN"
      bake_time = 1
    }

    autoscaling = {
      enabled            = true
      min                = 1 
      max                = 10
      metric             = "CPUUtilization"
      metric_target      = 70
      scale_in_cooldown  = 300
      scale_out_cooldown = 300
    }
  }
}

cicd = {
  github = true
  github_organization = "NazarSenchuk"
  registry  =  "649636402385.dkr.ecr.us-east-1.amazonaws.com"
  registry_region  = "us-east-1"
}