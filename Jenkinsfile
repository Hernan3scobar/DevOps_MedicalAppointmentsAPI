pipeline {
    agent any

    environment {
        // Environment variables (you can add more if needed)
        TF_VAR_region = 'us-west-2'  // Example Terraform variable
        TF_VAR_instance_type = 't2.micro'  // Example variable
        TF_VAR_secret_key = credentials('my-terraform-secret-key') // Retrieve a secret key
    }

    stages {
        // Checkout stage
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        // Terraform Init stage
        stage('Terraform Init') {
            steps {
                script {
                    runTerraformInit()
                }
            }
        }

        // Terraform Plan stage
        stage('Terraform Plan') {
            steps {
                script {
                    runTerraformPlan()
                }
            }
        }

        // Terraform Apply stage
        stage('Terraform Apply') {
            steps {
                script {
                    runTerraformApply()
                }
            }
        }

        // Run Ansible stage
        stage('Run Ansible') {
            steps {
                script {
                    runAnsiblePlaybook()
                }
            }
        }
    }

    post {
        always {
            // Clean the workspace if necessary
            cleanWs()
        }
    }
}

// Separar jenkinsfile

// Terraform functions
def runTerraformInit() {
    echo 'Initializing Terraform...'
    sh 'terraform init'
}

def runTerraformPlan() {
    echo 'Generating Terraform plan...'
    sh 'terraform plan -out=tfplan'
}

def runTerraformApply() {
    echo 'Applying Terraform...'
    sh 'terraform apply -auto-approve tfplan'
}

// Function to run Ansible
def runAnsiblePlaybook() {
    echo 'Running Ansible...'
    sh 'ansible-playbook -i inventory/hosts playbook.yml'
}
