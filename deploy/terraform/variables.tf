variable "app_label" {
  type        = string
  description = "label to match all k8s resource"
  default     = "nest"
}

variable "app_name" {
  type    = string
  default = "backend-nest"
}

variable "app_ns" {
  type    = string
  default = "nest"
}

variable "app_image" {
  type    = string
  default = "jeffqev/ci-nest:main"
}

variable "replicas" {
  type    = number
  default = 3
}

variable "service" {
  type = object({
    port        = number
    target_port = number
    type        = string
  })

  default = {
    port        = 80
    target_port = 3000
    type        = "NodePort"
  }
}
