pipeline {
    agent none  
    
    environment {
        DOCKER_USERNAME = 'quixq'  
        DOCKER_PASSWORD = credentials('dockerhub-creds') 
        DOCKER_IMAGE = 'app_quix' 
    }

    stages {
        stage('Checkout') {
            agent any  
            steps {
                checkout scm  
            }
        }

        stage('Build Docker Image') {
            agent { label 'jenks2' }  
            steps {
                script {
                    
                    sh 'docker build -t $DOCKER_USERNAME/$DOCKER_IMAGE:latest .'
                }
            }
        }

        stage('Run Tests') {
            agent { label 'jenks2' }  
            steps {
                script {
                    // выполняем тесты
                    def result = sh(script: 'docker run --rm $DOCKER_USERNAME/$DOCKER_IMAGE:latest npm run test', returnStatus: true)
                    if (result != 0) {
                        error "Tests failed"
                    }
                }
            }
        }

        stage('Push to Docker Hub') {
            agent { label 'jenks2' }  
            steps {
                script {
                    
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin'
                    }
                    
                    
                    sh 'docker tag $DOCKER_USERNAME/$DOCKER_IMAGE:latest $DOCKER_USERNAME/$DOCKER_IMAGE:$BUILD_NUMBER'
                    sh 'docker push $DOCKER_USERNAME/$DOCKER_IMAGE:$BUILD_NUMBER'
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image pushed to Docker Hub successfully!'
        }
        failure {
            echo 'Tests failed'
        }
    }
}
