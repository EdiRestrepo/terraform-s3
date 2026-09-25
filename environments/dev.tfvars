########## Provider ##########
aws_region  = "us-east-1"
aws_profile = "PSeminario"

########## VPC ##########
vpc_cidr = "192.168.0.0/24"
vpc_name = "VPC-ITMLab-VP"

########## Subredes publicas (Front) ##########
pub_subnets    = ["192.168.0.0/27", "192.168.0.32/27"]
pub_subnets_az = ["us-east-1a", "us-east-1d"]

########## Subredes privadas (Back) ##########
priv_subnets    = ["192.168.0.64/27", "192.168.0.96/27"]
priv_subnets_az = ["us-east-1a", "us-east-1d"]

########## Security Group ##########
sg_name        = "SG-Lab-ITM"
sg_description = "Security group prueba"

########## EC2 ##########
instance_name         = "EC2-Lab-ITM"
instance_type         = "t3.micro"
ami_id                = ""
root_volume_size      = 32
root_volume_type      = "gp3"
root_volume_encrypted = false
