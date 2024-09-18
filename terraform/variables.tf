variable "cidr_block" {
  type        = string
  description = "cidr block"
  default     = "14.0.0.0/16"

}

variable "vpc_name" {

  type        = string
  description = "vpc name"
  default     = "PARKING_LOT_MONITORING_VPC_TF"

}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["14.0.1.0/24", "14.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["14.0.2.0/24", "14.0.4.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "ingress_cidr" {
  type        = list(string)
  description = "Ingress cidr"
  default     = ["0.0.0.0/0"]
}

variable "egress_cidr" {
  type        = list(string)
  description = "egress cidr"
  default     = ["0.0.0.0/0"]
}


variable "parking_table_name" {
  type        = string
  description = "dynamodb table name"
  default     = "PARKING_LOTS_TF"
}

variable "parking_table_partition_key_name" {

  type        = string
  description = "dynamodb table partition key"
  default     = "Development"
  
}

variable "parking_table_sort_key_name" {

  type        = string
  description = "dynamodb table sort key"
  default     = "Area"
  
}

variable "update_lambda_function_name" {

  type        = string
  description = "name of update lambda function"
  default     = "UPDATE_PARKING_LOTS_TF"
  
}

variable "get_lambda_function_name" {

  type        = string
  description = "name of get lambda function"
  default     = "GET_PARKING_LOTS_TF"
  
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
  default     = "https://datamall2.mytransport.sg/ltaodataservice/CarParkAvailabilityv2"
  
}


variable "cron_expression_for_update_parking_lots_schedule" {
    description = "Cron expression to describe the update_parking_lots schedule. See https://docs.aws.amazon.com/scheduler/latest/UserGuide/schedule-types.html#cron-based for more information. Defaults to 1 am everyday."
    default     = "*/5 * * * ? *"
}
