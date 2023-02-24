pipeline {
  agent any

  environment {
    registry = "campex/gazprom-devops-app"
    registryCredential = 'dockerhub-credentials'
    dbPassword = credentials('db-password')
  }
  
  stages {
    stage('Building image') {
      steps {
        script {
          dockerImage = docker.build(registry + ":latest", '--build-arg DB_PASSWORD=$dbPassword .')
        }
      }
    }
    
    stage('Deploy Image') {
      steps {
        script {
          docker.withRegistry('', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }

      stage('Invoke pod rollout') {
        steps {
          script {
            def props = readProperties(file: '/var/lib/jenkins/jobs/gazprom-devops-pipeline/ansible-server.properties')

            def remote = [:]
            remote.name = 'ansible-server'
            remote.host = props['PRIVATE_IP']
            remote.user = 'ec2-user'
            remote.port = 22
            remote.identityFile = '/var/lib/jenkins/.ssh/id_rsa'
            remote.allowAnyHosts = true
            sshCommand remote: remote, command: "ansible-playbook -i ~/inventory.txt ~ec2-user/gazprom-devops-ansible/app/invoke-pods-rollout.yml"
          }
         }
      }
    }
  }
