pipeline {
  agent any
  stages {
    
    stage('build') {
      steps {
        echo 'Building the application'
      }
    }
    
    stage('test') {
      steps {
        echo 'Testing the application'
        sh "sbt test"
      }
    }
    
    stage('deploy') {
      steps {
        echo 'Deploying the application'
      }
    }
  }
}
