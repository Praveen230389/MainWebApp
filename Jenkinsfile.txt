pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY_ID')
  }

  stages {
    stage('Terraform Init & Apply') {
      steps {
        sh '''
          terraform init
          terraform validate
          terraform plan
          terraform apply -auto-approve
        '''
      }
    }

    stage('Generate Dynamic Inventory') {
  steps {
    sh '''
      PUBLIC_IP=$(terraform output -raw ec2_public_ip)
      echo "[myec2]" > inventory.ini
      echo "$PUBLIC_IP ansible_user=ec2-user" >> inventory.ini
      echo "Dynamic inventory generated:"
      cat inventory.ini
    '''
  }
}


    stage('Run Ansible Playbook') {
      steps {
        withCredentials([sshUserPrivateKey(credentialsId: 'ec2-ssh', keyFileVariable: 'SSH_KEY')]) {
          sh '''
            export ANSIBLE_HOST_KEY_CHECKING=False
            ansible-playbook -i inventory.ini playbook.yml --private-key $SSH_KEY
          '''
        }
      }
    }
  }
}
