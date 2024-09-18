resource "aws_dynamodb_table" "parking_table" {
    name                        = var.parking_table_name
    billing_mode                = "PAY_PER_REQUEST"
    deletion_protection_enabled = false

   

    hash_key        = var.parking_table_partition_key_name
    range_key       = var.parking_table_sort_key_name

    # Partition Key ( "Development" )
    attribute {
        name = var.parking_table_partition_key_name
        type = "S"
    }

    # Sort Key ("Area")
    attribute {
        name = var.parking_table_sort_key_name
        type = "S"
    }

    

    //global_secondary_index {
      //  name        = "${var.conn_status_table_sort_key_name}-index"
       // hash_key    = var.conn_status_table_sort_key_name
       // range_key   = var.conn_status_table_attr_status_key_name
       // projection_type = "ALL"
       
    //}

    lifecycle {
        ignore_changes = [
            read_capacity,
            write_capacity
        ]
    }
}


