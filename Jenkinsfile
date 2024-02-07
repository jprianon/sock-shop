pipeline {
    agent any
    
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
                        sh "ssh -i /home/ec2-user/data_enginering_machine_jenkins.pem ec2-user@13.36.223.205 'cd /opt/sock-shop/ && docker-compose up -d'"
                    }
                }
            }
        }
    }
}
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