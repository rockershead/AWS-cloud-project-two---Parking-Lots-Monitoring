terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.00"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
}


module "parking_lots"{

 source                                           = "./parking_lots"
 vpc_name                                         = var.vpc_name
 cidr_block                                       = var.cidr_block
 public_subnet_cidrs                              = var.public_subnet_cidrs
 private_subnet_cidrs                             = var.private_subnet_cidrs
 azs                                              = var.azs
 ingress_cidr                                     = var.ingress_cidr
 egress_cidr                                      = var.egress_cidr
 update_lambda_function_name                      = var.update_lambda_function_name
 get_lambda_function_name                         = var.get_lambda_function_name      
 API_URL                                          = var.API_URL
 parking_table_partition_key_name                 = var.parking_table_partition_key_name
 parking_table_name                               = var.parking_table_name
 update_lambda_zip_filename                       = var.update_lambda_zip_filename
 get_lambda_zip_filename                          = var.get_lambda_zip_filename
 parking_table_sort_key_name                      = var.parking_table_sort_key_name
 cron_expression_for_update_parking_lots_schedule = var.cron_expression_for_update_parking_lots_schedule


}