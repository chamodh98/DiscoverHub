pipeline {
    agent any

    environment {
        LC_ALL = 'en_US.UTF-8'
        LANG = 'en_US.UTF-8'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Test') {
            steps {
                sh 'fastlane ci'
            }
        }
    }

    post {
        success {
            echo '✅ Build & Tests Passed'
        }
        failure {
            echo '❌ Build or Tests Failed'
        }
    }
}
