pipeline {
    agent any
    tools {
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "Terraform"
    }
    parameters {
        string(name: 'WORKSPACE', defaultValue: 'development', description:'setting up workspace for terraform')
    }
    environment {
        //TF_HOME = tool('Terraform')
        //TF_IN_AUTOMATION = "true"
        //PATH = "$TF_HOME:$PATH"
        ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
        SECRET_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
            stage('TerraformInit'){
            steps {
                dir('./'){
                    sh "terraform init -input=false"
                    sh "echo \$PWD"
                    sh "whoami"
                    sh "ls -ltra"
                }
            }
        }

        stage('TerraformValidate'){
            steps {
                dir('./'){
                    sh "terraform validate"
                    sh "ls -ltra"
                }
            }
        }
        
        stage('TerraformPlan'){
            steps {
                dir('./'){
                    script {
                        try {
                            sh "terraform workspace new ${params.WORKSPACE}"
                        } catch (err) {
                            sh "terraform workspace select ${params.WORKSPACE}"
                        }
                        sh "terraform plan -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' --var-file='environments/${environment}.tfvars' \
                        -out terraform.tfplan;echo \$? > status" 
                        stash name: "terraform-plan", includes: "terraform.tfplan"
                        sh "ls -ltra"
                    }
                }
            }
        }
        stage('TerraformApply'){
            steps {
                script{
                    def apply = false
                    try {
                        input message: 'Can you please confirm the apply', ok: 'Ready to Apply the Config'
                        apply = true
                    } catch (err) {
                        apply = false
                         currentBuild.result = 'UNSTABLE'
                    }
                    if(apply){
                        dir('./'){
                            unstash "terraform-plan"
                            sh 'terraform apply terraform.tfplan'
                            sh "ls -ltra"
                        }
                    }
                }
            }
        }
    }
}
