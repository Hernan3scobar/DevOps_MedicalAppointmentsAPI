pipeline {
    agent any

    parameters {
        choice(name: 'ACTION', choices: ['apply', 'destroy'], description: 'Select whether to apply or destroy the infrastructure')
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "🔄 Cloning repository from ${env.GIT_REPO_URL} (branch: ${env.GIT_BRANCH})"
                sh 'rm -rf project && git clone -b "$GIT_BRANCH" "$GIT_REPO_URL" project'
            }
        }

        stage('Prepare Configuration') {
            steps {
                withCredentials([
                    string(credentialsId: 'MY_SSH_KEY_PUBLIC', variable: 'MY_SSH_KEY_PUBLIC'),
                    string(credentialsId: 'MY_SSH_KEY_PRIVATE', variable: 'MY_SSH_KEY_PRIVATE')
                ]) {
                    dir('project/terraform') {
                        sh '''
                            cp terraform.tfvars.example terraform.tfvars
                            echo "" >> terraform.tfvars
                            echo 'ssh_public_key = "'"${MY_SSH_KEY_PUBLIC}"'"' >> terraform.tfvars
                            echo 'ssh_private_key = "'"${MY_SSH_KEY_PRIVATE}"'"' >> terraform.tfvars
                            echo "" >> terraform.tfvars
                        '''
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([ 
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']
                ]) {
                    dir('project/terraform') {
                        // Asegurando que terraform init no falle por configuraciones existentes
                        sh 'terraform init -input=false || true'
                    }
                }
            }
        }

        stage('Terraform Import') {
            steps {
                withCredentials([ 
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']
                ]) {
                    dir('project/terraform') {
                        // Importa los recursos existentes
                        sh '''
                            terraform import module.ec2.aws_iam_role.ec2_ssm_role EC2SSMRole
                            terraform import module.ec2.aws_iam_instance_profile.ec2_profile EC2SSMProfile
                            terraform import module.ec2.aws_iam_policy.ssm_read_policy arn:aws:iam::307946663677:policy/EC2ReadSSMSecure
                            terraform import module.ec2.aws_iam_policy.budget_policy arn:aws:iam::307946663677:policy/AllowBudgetManagement
                            terraform import module.ec2.aws_key_pair.ssh_key my_key_pair
                            terraform import module.budget.aws_budgets_budget.daily_budget 307946663677:daily-budget
                        '''
                    } //                            terraform import module.rds.aws_db_subnet_group.rds rds-subnet-group
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
                        credentialsId: 'aws-credentials', 
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('project/terraform') {
                        script {
                            def planStatus = sh(
                                script: 'terraform plan -detailed-exitcode -var-file=terraform.tfvars',
                                returnStatus: true
                            )
                            
                            if (planStatus == 0) {
                                echo "✅ No infrastructure changes detected."
                            } else if (planStatus == 2) {
                                echo "🔧 Infrastructure changes detected. Preparing to apply..."
                            } else {
                                error "❌ terraform plan failed."
                            }
                        }
                    }
                }
            }
        }

        stage('Terraform Apply or Destroy') {
            when {
                expression {
                    return (params.ACTION == 'apply' || params.ACTION == 'destroy')
                }
            }
            steps {
                withCredentials([ 
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']
                ]) {
                    dir('project/terraform') {
                        script {
                            if (params.ACTION == 'apply') {
                                echo "🚀 Applying Terraform changes..."
                                sh 'terraform apply -auto-approve -var-file=terraform.tfvars'
                            }
                        }
                    }
                }
            }
        }
        
        stage('Wait for 10 minutes') {
            steps {
                script {
                    // Espera 10 minutos (600 segundos)
                    echo "Waiting for 10 minutes before destroying infrastructure..."
                    sleep 600
                }
            }
        }
        
        stage('Terraform Destroy') {
            steps {
                withCredentials([ 
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']
                ]) {
                    dir('project/terraform') {
                        script {
                            echo "🧹 Destroying Terraform infrastructure..."
                            sh 'terraform destroy -auto-approve -var-file=terraform.tfvars'
                        }
                    }
                }
            }
        }
    }
    
    

    post {
        always {
            dir('project/terraform') {
                echo "Cleaning up the terraform.tfvars file..."
                sh 'rm -f terraform.tfvars 2>/dev/null || true'
            }
        }
    }
}
