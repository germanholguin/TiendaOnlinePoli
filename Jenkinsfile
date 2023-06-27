pipeline {
    agent any
    stages {
        stage('Build and tag images') {
            steps {
                sh 'sudo docker build -t malejandra1801/jenkins:etiqueta .'
                sh 'sudo docker tag malejandra1801/jenkins:etiqueta ghcr.io/malejandra1801/jenkins:etiqueta'
            }
        }
        stage('Push images') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-docker-credentials', passwordVariable: 'TOKEN', usernameVariable: 'USERNAME')]) {
                    sh 'sudo docker login ghcr.io -u malejandra1801 -p $TOKEN'
                    sh 'sudo docker push ghcr.io/malejandra1801/jenkins:etiqueta'
                }
            }
        }
        stage('Clean up old containers') {
            steps {
                script {
                    def containers = sh(script: 'sudo docker ps -q -f ancestor=malejandra1801/jenkins', returnStdout: true).trim()
                    if (containers) {
                        sh "sudo docker stop ${containers}"
                        sh "sudo docker rm ${containers}"
                    }
                }
            }
        }
        stage('Remove conflicting container') {
            steps {
                script {
                    def conflictingContainer = sh(script: 'sudo docker ps -a -q -f name=jenkins', returnStdout: true).trim()
                    if (conflictingContainer) {
                        sh "sudo docker stop ${conflictingContainer}"
                        sh "sudo docker rm ${conflictingContainer}"
                    }
                }
            }
        }
        stage('Run new image') {
            steps {
                sh 'sudo docker run -d --name jenkins -p 80:80 ghcr.io/malejandra1801/jenkins:etiqueta'
            }
        }
    }
}