pipeline {
    
    agent {
    docker {
      image 'python:3.11-slim'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // mount Docker socket to access the host's Docker daemon
    }
  }
    
    environment {
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        
        stage('Checkout'){
           steps {
                git branch: 'main', url: 'https://github.com/RahmanMomin/cicd-end-to-end'
           }
        }

        stage('Build Docker'){
            steps{
                script{
                    sh '''
                    echo 'Buid Docker Image'
                    docker build -t mominrahman/cicd-e2e:${BUILD_NUMBER} .
                    '''
                }
            }
        }

        stage('Push the artifacts'){
           steps{
                script{
                     docker.withRegistry('', 'docker-cred') { // Replace 'docker-credentials-id' with your Jenkins credentials ID
                sh '''
                echo 'Push to Repo'
                docker push mominrahman/cicd-e2e:${BUILD_NUMBER}
                '''
                }
            }
        }
        
        stage('Checkout K8S manifest SCM'){
            steps {
                git branch: 'main', url: 'https://github.com/RahmanMomin/cicd-end-to-end/deploy'
            }
        }
        
        stage('Update K8S manifest & push to Repo'){
            steps {
                script{
                    withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                        sh '''
                        cd deploy
                        cat deploy.yaml
                        sed -i "s/32/${BUILD_NUMBER}/g" deploy.yaml
                        cat deploy.yaml 
                        git add deploy.yaml
                        git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                        git remote -v
                        git push https://github.com/RahmanMomin/cicd-end-to-end.git HEAD:main
                        '''                        
                    }
                }
            }
        }
    }
}
