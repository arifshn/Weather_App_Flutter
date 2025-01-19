pipeline {
    agent any

    environment {
        FLUTTER_HOME = '/usr/local/flutter'
        ANDROID_HOME = '/usr/local/android-sdk'
        PATH = "$FLUTTER_HOME/bin:$ANDROID_HOME/platform-tools:$PATH"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/arifshn/Weather_App_Flutter.git'
            }
        }

        stage('Dependencies') {
            steps {
                sh 'flutter pub get'
            }
        }

        stage('Build') {
            steps {
                sh 'flutter build apk --release'
            }
        }

        stage('Test') {
            steps {
                sh 'flutter test'
            }
        }

        stage('Dockerize') {
            steps {
                sh '''
                docker build -t arifshn/weather_app .
                docker tag arifshn/weather_app arifshn/weather_app:latest
                docker push arifshn/weather_app:latest
                '''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deployment is completed.'
            }
        }
    }
}
