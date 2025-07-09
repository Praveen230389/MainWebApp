pipeline {
  agent any

  stages {
    stage('Terraform Plan') {
      steps {
        withCredentials([
          string(credentialsId: 'AWS_ACCESS_KEY_ID_ID', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'AWS_SECRET_ACCESS_KEY_ID', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            terraform init
            terraform validate
            terraform plan
            terraform apply -auto-approve
          '''
        }
        // This block uses your SSH key for Ansible
        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh', keyFileVariable: 'SSH_KEY')]) {
          sh '''
            ansible-playbook -i inventory.ini playbook.yml --private-key $SSH_KEY
          '''
        }
      }
    }
  }
}
