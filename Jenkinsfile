pipeline {
    agent any

    environment {
        LC_ALL = 'en_US.UTF-8'
        LANG   = 'en_US.UTF-8'
        PATH   = "/usr/local/opt/ruby/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Ruby') {
            steps {
                sh '''
                  which ruby
                  ruby -v
                  which bundle
                  bundle -v
                '''
            }
        }

        stage('Install Gems') {
            steps {
                sh 'bundle install'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'bundle exec fastlane ci'
            }
        }
    }
}
