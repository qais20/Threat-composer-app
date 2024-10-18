variable "a_record_name" {
  type        = string
  description = "A record name"
  default     = "tm.lab.qaisnavaei.com"
}

variable "alb_dns_name" {
  type = string
  description = "The DNS name of the Application Load Balancer"
}
