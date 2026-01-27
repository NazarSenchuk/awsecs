variable "general" {
  description = "General project configuration"
  type = object({
    environment = string
    project     = string
    region      = string
    tags        = optional(map(string), {})
  })
}

variable "infrastructure" {
  description = "Infrastructure configuration"
  type = object({
    type         = string
    fargate_spot = optional(bool, false )
    platform     = optional(string, "X86_64")
    ec2_types    = optional(list(string), [])
  })
}

variable "services" {
  description = "Deployment configuration for each service"
  type = map(object({
    name          = string
    img           = string
    desired_count = number
    alb_path      = string
    health_check  = optional(string ,"/") 
    blue_green    = optional(bool, false)
    target_port   = optional(number, 80)
    spot_percent  = optional(number , 40)
    requirements = optional(object({
      cpu    = optional(number, 256)
      memory = optional(number, 512)
    }), {
      cpu    = 256
      memory = 512
    })

    deploy = object({
      enabled   = bool
      strategy  = string
      bake_time = optional(number, 5)
    })

    autoscaling = object({
      enabled            = bool
      min                = number
      max                = number
      metric             = optional(string, "CPUUtilization")
      metric_target      = optional(number, 70)
      scale_in_cooldown  = optional(number, 300)
      scale_out_cooldown = optional(number, 300)
    })
  }))
}
variable "cicd" {}