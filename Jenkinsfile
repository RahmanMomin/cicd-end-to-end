pipeline {
    agent any 
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}" // Image tag for Docker
    }

    stages {
        stage('Checkout Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/RahmanMomin/cicd-end-to-end'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                echo 'Building Docker Image'
                docker build -t mominrahman/cicd-e2e:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'docker-cred') { // Use your Docker credentials ID
                        sh '''
                        echo 'Pushing Docker Image to Docker Hub'
                        docker push mominrahman/cicd-e2e:${BUILD_NUMBER}
                        '''
                    }
                }
            }
        }

        stage('Checkout K8S Manifest Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/RahmanMomin/cicd-end-to-end'
            }
        }

        stage('Update K8S Manifest and Push Changes') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                        sh '''
                        echo 'Updating Kubernetes Manifest'
                        cd deploy
                        sed -i "s/32/${BUILD_NUMBER}/g" deploy.yaml
                        cat deploy.yaml 
                        echo 'Committing and Pushing Manifest Changes'
                        git add deploy.yaml
                        git commit -m "Updated deploy.yaml with image tag ${BUILD_NUMBER}"
                        git push https://${GITHUB_TOKEN}@github.com/RahmanMomin/cicd-end-to-end.git HEAD:main
                        '''
                    }
                }
            }
        }
    }
}
