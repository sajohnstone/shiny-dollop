
variable "myip" {
  type        = list(string)
  description = "My IP to allow SSH access into the bastion server"
  default = ["127.0.0.1"]
}

variable "bastion_enabled" {
  description = "Spins up a bastion host if enabled"
  type        = bool
  default     = true
}