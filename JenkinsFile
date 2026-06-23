pipeline {
    agent any

    environment {
        // Remplace par ton vrai pseudo DockerHub
        DOCKER_USER = 'ndongmo'
        IMAGE_NAME  = 'landing-page'
        // On utilise le numéro de build de Jenkins comme tag (ex: v1, v2, v3...) pour la traçabilité
        REGISTRY_TAG = "${DOCKER_USER}/${IMAGE_NAME}:build-${BUILD_NUMBER}"
    }

    stages {
        stage('Clone et Vérification') {
            steps {
                echo "🚀 Récupération du code depuis GitHub..."
                checkout scm
            }
        }

        stage('Docker Build') {
            steps {
                echo "📦 Construction de l'image Docker avec le tag unique..."
                sh "docker build -t ${REGISTRY_TAG} ."
            }
        }

        stage('Docker Push') {
            steps {
                echo "📤 Connexion et publication sur DockerHub..."
                // C'est ici qu'on utilise l'identifiant secret de Jenkins (qu'on va créer juste après)
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh "echo ${PASS} | docker login -u ${USER} --password-stdin"
                    sh "docker push ${REGISTRY_TAG}"
                }
            }
        }

        stage('Déploiement Continu (CD)') {
            steps {
                echo "🌐 Nettoyage et mise en production de la nouvelle version..."
                // On stoppe l'ancienne version si elle existe (le || true évite que le build plante au premier lancement)
                sh "docker stop ${IMAGE_NAME} || true"
                sh "docker rm ${IMAGE_NAME} || true"
                // On lance le nouveau conteneur sur le port 80 de notre machine AWS
                sh "docker run -d -p 80:80 --name ${IMAGE_NAME} --restart unless-stopped ${REGISTRY_TAG}"
            }
        }
    }

    post {
        success {
            echo "✅ Félicitations ! La Landing Page est en ligne et à jour."
        }
        failure {
            echo "❌ Le déploiement a échoué.  Vérifie les logs de l'étape en erreur."
        }
    }
}