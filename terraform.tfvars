#Network 
subnet_public_name = "jp-public-subnet"
subnet_private_name = "jp-private-subnet"
rtb_public_name = "jp-rtb-public"
vpc_name = "jp-vpc"
#public_subnets_igw_name = "jp-public_subnets_igw"
nat_gw_name = "jp-nat_gw_name"
#private_db_subnet_group = "jp-private_db_subnet_group"
elastic_ip_name = "jp-elastic_ip_name"
vpc = "10.0.0.0/16"
public_subnets_cidrs = ["10.0.128.0/20", "10.0.144.0/20"]
private_subnets_cidrs = ["10.0.0.0/19", "10.0.32.0/19"]
available_zones = [ "eu-west-3a" ]

#EC2
namespace = "Datascientest"
key_name = "Datascientest-jp"
instance_type = "t3a.medium"