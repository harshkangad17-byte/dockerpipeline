pipeline {
    agent any

    environment {
        IMAGE = 'harshkangad17/dockerpipeline'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t $IMAGE:$BUILD_NUMBER -t $IMAGE:latest .'
            }
        }

        stage('Test Image') {
            steps {
                sh '''
                    docker run -d --name test-$BUILD_NUMBER $IMAGE:$BUILD_NUMBER
                    sleep 5
                    docker exec test-$BUILD_NUMBER node -e "fetch('http://localhost:3000').then(r => r.text()).then(console.log)"
                '''
            }
            post {
                always {
                    sh 'docker rm -f test-$BUILD_NUMBER || true'
                }
            }
        }

        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh '''
                        echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
                        docker push $IMAGE:$BUILD_NUMBER
                        docker push $IMAGE:latest
                        docker logout
                    '''
                }
            }
        }
    }

    post {
        success { echo 'Image built, tested and pushed to Docker Hub' }
        failure { echo 'Pipeline failed - check Console Output' }
    }
}