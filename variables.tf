variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "uksouth"

}
variable "tags" {
  description = "A map of tags to apply to all resources in this example."
  type        = map(string)
  default = {
    costcode    = "123456"
    owner       = "terraform"
    environment = "dev"
    test        = "some_tag"
    ANOTHER_TAG = "another_tag"
  }
}
variable "vm_config" {
  description = "A map of tags to apply to all resources in this example."
  type = map(object({
    name     = optional(string)
    location = optional(string)
    zone     = optional(number, 1)
    sku_size = string
  }))
}
