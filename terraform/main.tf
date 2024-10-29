provider "aws" {
  region = "eu-west-1"

}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "networking" {
  source                   = "./modules/networking" 
  namespace                = var.namespace
  enable_nat_gateway       = var.enable_nat_gateway
  single_nat_gateway       = var.single_nat_gateway
  vpc                      = var.vpc
  available_zones          = var.available_zones
  public_subnets_cidrs     = var.public_subnets_cidrs
  private_subnets_cidrs    = var.private_subnets_cidrs
}


locals {
  cluster_name = "SockShop-eks"
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  #version                         = "19.15.3"
  cluster_name                    = local.cluster_name
  cluster_version                 = "1.28"
  vpc_id                          = module.networking.vpc_id
  subnet_ids                      = module.networking.private_subnets_ids
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true



  eks_managed_node_group_defaults = {
    ami_type                    = "AL2_x86_64"
    associate_public_ip_address = true
    iam_role_attach_cni_policy = true
  }

  eks_managed_node_groups = {
    my-group = {
      name = "node-group-1"
      instance_types = ["t3a.medium"]
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}


# Définition d'un rôle IAM pour l'API EKS
resource "aws_iam_role" "EKSClusterRole" {
  name = "EKSClusterRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    Name = "EKSClusterRole"
  }
}

# Attacher les politiques IAM nécessaires
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.EKSClusterRole.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.EKSClusterRole.name
}

#provider "kubernetes" {
#  config_path = "~/.kube/config" # Assurez-vous que le chemin est correct pour votre configuration Kube
#}
#
#resource "kubernetes_namespace" "sock_shop" {
#  metadata {
#    name = "sock-shop"
#  }
#}
#
#resource "kubernetes_config_map" "aws_auth" {
#  metadata {
#    name      = "aws-auth"
#    namespace = "kube-system"
#  }
#
#  data = {
#    mapRoles = <<EOT
#- rolearn: arn:aws:iam::715841363614:role/SockShop-eks-cluster-20241008092353383900000001
#  username: jprianon
#  groups:
#    - system:masters
#EOT
#    mapUsers = <<EOT
#- userarn: arn:aws:iam::715841363614:user/jprianon
#  username: jprianon
#  groups:
#    - system:masters
#EOT
#  }
#}
#
#resource "kubernetes_deployment" "carts" {
#  metadata {
#    name      = "carts"
#    namespace = kubernetes_namespace.sock_shop.metadata[0].name
#    labels = {
#      name = "carts"
#    }
#  }
#
#  spec {
#    replicas = 1
#
#    selector {
#      match_labels = {
#        name = "carts"
#      }
#    }
#
#    template {
#      metadata {
#        labels = {
#          name = "carts"
#        }
#      }
#
#      spec {
#        container {
#          name  = "carts"
#          image = "weaveworksdemos/carts:0.4.8"
#
#          env {
#            name  = "JAVA_OPTS"
#            value = "-Xms64m -Xmx128m -XX:+UseG1GC -Djava.security.egd=file:/dev/urandom -Dspring.zipkin.enabled=false"
#          }
#
#          resources {
#            limits = {
#              cpu    = "300m"
#              memory = "500Mi"
#            }
#            requests = {
#              cpu    = "100m"
#              memory = "200Mi"
#            }
#          }
#
#          port {
#            container_port = 80
#          }
#
#          security_context {
#            run_as_non_root = true
#            run_as_user     = 10001
#            capabilities {
#              drop = ["ALL"]
#              add  = ["NET_BIND_SERVICE"]
#            }
#            read_only_root_filesystem = true
#          }
#
#          volume_mount {
#            mount_path = "/tmp"
#            name       = "tmp-volume"
#          }
#        }
#
#        volume {
#          name = "tmp-volume"
#          empty_dir {
#            medium = "Memory"
#          }
#        }
#
#        node_selector = {
#          "beta.kubernetes.io/os" = "linux"
#        }
#      }
#    }
#  }
#}
#
#resource "kubernetes_service" "carts" {
#  metadata {
#    name      = "carts"
#    namespace = kubernetes_namespace.sock_shop.metadata[0].name
#    annotations = {
#      "prometheus.io/scrape" = "true"
#    }
#    labels = {
#      name = "carts"
#    }
#  }
#
#  spec {
#    port {
#      port        = 80
#      target_port = 80
#    }
#
#    selector = {
#      name = kubernetes_deployment.carts.metadata[0].name
#    }
#  }
#}

# Répétez les ressources pour les autres déploiements et services (carts-db, catalogue, etc.)
# Assurez-vous d'adapter les images, noms, et spécificités de chaque déploiement/service.



#module "elb" {
#  source                   = "./modules/elb"
#  lb_name                  = var.lb_name
#  #internal                 = false
#  security_group_id        = module.networking.sg_pub_id
#  subnet_ids               = module.networking.public_subnets_ids
#  #protocol                 = "HTTP"
#  #port                     = 80
#  #target_group_name        = var.target_group_name
#  vpc_id                   = module.networking.vpc_id
#  #health_check_path        = "/"
#  #health_check_timeout     = 5
#  #health_check_interval    = 30
#  #healthy_threshold        = 2
#  #unhealthy_threshold      = 2
#  wordpress_id             = module.ec2.wordpress_ids
#  private_subnets_cidrs    = module.networking.private_subnets_ids
#  wordpress_autoscaling_id = module.ec2.webservers-autoscaling_ids
#}
