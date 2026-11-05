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
admin_cidr = "0.0.0.0/0" # Recomendado: tu IP publica con /32

########## EC2 ##########
instance_name_control_plane = "EC2-Lab-ITM-Control-Plane"
instance_name_worker        = "EC2-Lab-ITM-Worker"
instance_type_control_plane = "t3.medium"
instance_type_worker        = "t3.large"
ami_id                      = ""
root_volume_size            = 32
root_volume_type            = "gp3"
root_volume_encrypted       = false
