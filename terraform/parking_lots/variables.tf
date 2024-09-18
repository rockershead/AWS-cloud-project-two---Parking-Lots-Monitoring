variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"

}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"

}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"

}

variable "cidr_block" {
  type        = string
  description = "cidr block"


}

variable "vpc_name" {

  type        = string
  description = "vpc name"


}

variable "ingress_cidr" {
  type        = list(string)
  description = "Ingress cidr"

}

variable "egress_cidr" {
  type        = list(string)
  description = "egress cidr"

}

variable "parking_table_name" {
  type        = string
  description = "dynamodb table name"
 
}

variable "parking_table_partition_key_name" {

  type        = string
  description = "dynamodb table partition key"
  
  
}

variable "parking_table_sort_key_name" {

  type        = string
  description = "dynamodb table sort key"
  
  
}


variable "update_lambda_function_name" {

  type        = string
  description = "name of update lambda function"
  
  
}

variable "update_lambda_zip_filename" {

  type        = string
  description = "name of zipped lambda"
  default     = "update_parking_lots.zip"
  
}

variable "get_lambda_zip_filename" {

  type        = string
  description = "name of zipped lambda"
  default     = "get_parking_lots.zip"
  
}

variable "API_URL" {
  type        = string
  description = "URL of API"
  
  
}

variable "cron_expression_for_update_parking_lots_schedule" {
    description = "Cron expression to describe the update_parking_lots schedule. See https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html#cron-based for more information. Defaults to 1 am everyday."
    
}

variable "get_lambda_function_name" {

  type        = string
  description = "name of get lambda function"
  
}
