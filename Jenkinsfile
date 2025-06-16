pipeline {
    agent any

    tools {
        terraform 'Terraform_Manual_Install' // Name must match Jenkins tool config
    }

    environment {
        TF_VAR_bucket_name = "jenkins-tf-newtest-${UUID.randomUUID().toString().substring(0, 8).toLowerCase()}"
         TF_VAR_aws_region = 'us-east-1'
    }

    stages {
        stage('Checkout Source Code') {
            steps {
                echo '1. Checking out Git repository...'
                script {
                    checkout scm
                }
            }
        }

        stage('Terraform Init') {
            steps {
                echo '2. Initializing Terraform backend and providers...'
                script {
                    withAWS(credentials: 'aws-terraform-credentials') {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo '3. Generating Terraform execution plan...'
                script {
                    withAWS(credentials: 'aws-terraform-credentials') {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'tfplan', fingerprint: true
                }
            }
        }

        stage('Terraform Apply - Manual Approval') {
            steps {
                echo '4. Waiting for manual approval to apply Terraform changes...'
                input message: 'Review the plan and click "Apply Now" to proceed with infrastructure creation.', ok: 'Apply Now'
                script {
                    withAWS(credentials: 'aws-terraform-credentials') {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
                echo 'Terraform Apply Complete. Resources should now be deployed.'
            }
        }

        /*
        stage('Terraform Destroy - Manual Confirmation') {
            steps {
                echo '5. WARNING: This stage will DESTROY all Terraform-managed resources for this state.'
                input message: 'Are you absolutely sure you want to DESTROY ALL resources created by this pipeline?', ok: 'DESTROY NOW!'
                script {
                    withAWS(credentials: 'aws-terraform-credentials') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
                echo 'Terraform Destroy Complete. Resources have been removed.'
            }
        }
        */
    }

    post {
        success {
            echo 'Pipeline completed successfully! Check AWS console for resources.'
        }
        failure {
            echo 'Pipeline failed. Review the console output for errors.'
        }
        always {
            echo 'Cleaning up workspace...'
            // cleanWs() // Uncomment if you want Jenkins to clean the workspace after every build
        }
    }
}
