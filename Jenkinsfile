pipeline {
    agent any
<<<<<<< HEAD
    
    stages {
        stage('Checkout') {
            steps {
                // Étape pour récupérer le code depuis le référentiel Git
                git 'https://github.com/jprianon/jenkins-jp'
            }
        }
        
        //stage('Build and Push Docker Images') {
        //    steps {
        //        // Étape pour construire et pousser les images Docker si nécessaire
        //        // Vous pouvez personnaliser cette étape en fonction de votre projet
        //        script {
        //            // Exemple de construction et de poussée d'une image Docker
        //            docker.build('nom-de-votre-image')
        //            docker.withRegistry('https://votre-registry-docker.com', 'votre-credential-id') {
        //                docker.image('nom-de-votre-image').push('latest')
        //            }
        //        }
        //    }
        //}
        
        stage('Deploy with Docker Compose') {
            steps {
                // Étape pour déployer le Docker Compose sur le serveur
                script {
                    // Assurez-vous que Docker est installé sur le serveur Jenkins
                    // Exécutez la commande docker-compose sur le serveur distant
                    sshagent(['sock-shop-id']) {
                        sh "ssh -i /home/ec2-user/data_sock_shop.pem ec2-user@10.202.30.29 -o StrictHostKeyChecking=no 'cd /opt/sock-shop/ && sudo docker-compose up -d'"
=======
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "eu-west-2"
    }
    parameters{
        choice(name: 'ENVIRONMENT', choices: ['create', 'destroy'], description: 'create and destroy cluster with one click')
    }
    stages {

        stage("Deploy sock-shop to EKS") {
             when {
                expression { params.ENVIRONMENT == 'create' }
            }
            steps {
                script {
                    dir('kubernetes/micro-service') {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
>>>>>>> ee389f2 (Add new jenkinsfile)
                    }
                }
            }
        }
<<<<<<< HEAD
    }
}
// TEST
//    post {  
//        always {
//            // Étape facultative pour nettoyer les ressources après le déploiement
//            // Par exemple, supprimer les images Docker temporaires - 
//            script {
//                docker.image('nom-de-votre-image').remove()
//            }
//        }
//    }
//}
=======

         stage("Deploy ingress rule to EKS") {
             when {
                expression { params.ENVIRONMENT == 'create' }
            }
            steps {
                script {
                    dir('kubernetes/ingress-rule') {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }

         stage("Create nginx-conroller & route53") {
             when {
                expression { params.ENVIRONMENT == 'create' }
            }
            steps {
                script {
                    dir('kubernetes/nginx-controller') {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }

       

         stage("destroy prometheus") {
             when {
                expression { params.ENVIRONMENT == 'destroy' }
            }
            steps {
                script {
                    dir('kubernetes/prometheus-helm') {
                        sh "terraform destroy -auto-approve"
                    }
                }
            }
        }


        stage("Destroy sock-shop in EKS") {
             when {
                expression { params.ENVIRONMENT == 'destroy' }
            }
            steps {
                script {
                    dir('kubernetes/micro-service') {
                        sh "terraform destroy -auto-approve"
                    }
                }
            }
        }

        stage("Destroy ingress rule in EKS") {
             when {
                expression { params.ENVIRONMENT == 'destroy' }
            }
            steps {
                script {
                    dir('kubernetes/ingress-rule') {
                        sh "terraform destroy -auto-approve"
                    }
                }
            }
        }
        
         stage("destroy nginx-conroller") {
             when {
                expression { params.ENVIRONMENT == 'destroy' }
            }
            steps {
                script {
                    dir('kubernetes/nginx-controller') {
                         sh "terraform destroy -auto-approve"
                    }
                }
            }
        }

    }
}
>>>>>>> ee389f2 (Add new jenkinsfile)
