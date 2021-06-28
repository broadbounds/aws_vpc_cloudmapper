pipeline {
  agent any
  parameters {
    string(name: 'WORKSPACE', defaultValue: 'development', description:'setting up workspace for terraform')
  }
  environment {
    TF_HOME = tool('terraform-0.15.3')
    TF_IN_AUTOMATION = "true"
    PATH = "$TF_HOME:$PATH"
    ACCESS_KEY = credentials('AWS_ACCESS_KEY_ID')
    SECRET_KEY = credentials('AWS_SECRET_ACCESS_KEY')
  }
  stages {
    stage('TerraformInit'){
        steps {
            sh "terraform init -input=false"
        }
    }
    stage('Terraform workspace') {
        steps {
          script {
                try {
                    sh "terraform workspace new ${params.WORKSPACE}"
                } catch (err) {
                    sh "terraform workspace select ${params.WORKSPACE}"
                }
          }
        }
    }
    stage('TerraformPlan'){
        steps {
            script {
                echo "terraform moving to destroy"
            }
        }
    }
    stage('TerraformApply'){
        steps {
            script{
                sh "terraform destroy -auto-approve -var 'access_key=$ACCESS_KEY' -var 'secret_key=$SECRET_KEY' "
            }
        }
    }
  }

}
