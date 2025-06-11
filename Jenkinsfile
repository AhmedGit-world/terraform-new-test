// Jenkinsfile
pipeline {
    // Explicitly run this pipeline on the Jenkins master controller.
    agent {
        label 'master'
    }

    // Environment variables for the pipeline.
    // TF_VAR_bucket_name will be automatically picked up by Terraform as a variable.
    environment {
        // Generate a unique bucket name for each run using a short UUID
        TF_VAR_bucket_name = "jenkins-tf-newtest-${UUID.randomUUID().toString().substring(0, 8).toLowerCase()}"
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
                    // Use 'withAWS' to securely inject AWS credentials as environment variables
                    // 'aws-terraform-credentials' is the ID you configured in Jenkins
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
                        // -out=tfplan saves the plan to a binary file for consistent application
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
            // Optional: Archive the plan file for review in Jenkins build artifacts
            post {
                always {
                    archiveArtifacts artifacts: 'tfplan', fingerprint: true
                }
            }
        }

        stage('Terraform Apply - Manual Approval') {
            steps {
                echo '4. Waiting for manual approval to apply Terraform changes...'
                // This input step pauses the pipeline until a user approves.
                // Highly recommended for infrastructure changes!
                input message: 'Review the plan and click "Apply Now" to proceed with infrastructure creation.', ok: 'Apply Now'
                script {
                    withAWS(credentials: 'aws-terraform-credentials') {
                        // -auto-approve is used because we have a manual approval gate before this.
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
                echo 'Terraform Apply Complete. Resources should now be deployed.'
            }
        }

        // Optional Stage: Terraform Destroy
        // This stage is commented out by default for safety.
        // Uncomment it in your Jenkinsfile, commit, push, and run the pipeline
        // when you explicitly want to destroy the created resources.
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

    // Post-build actions: run after all stages complete (success or failure)
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
