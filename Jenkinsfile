pipeline {
    agent any
    stages {
        stage('Build Docker image'){
            steps {
                echo "Hello"
                sh 'ls'
                sh 'docker build -t  onetrip/docker_jenkins_react:${BUILD_NUMBER} .'
            }
        }
        stage('Docker deploy'){
            steps {
        		sh "docker run -itd -p 80:80 onetrip/docker_jenkins_react:${BUILD_NUMBER}"
            }
        }
    }
}