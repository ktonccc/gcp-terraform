pipeline {
    agent any
    options {disableConcurrentBuilds()}
    environment {
        GOOGLE_PROJECT_ID = "esoteric-stream-410118" 
        GOOGLE_PROJECT_NAME = "My First Project"
        GOOGLE_APPLICATION_CREDENTIALS = credentials('service-account-total-control')
        GOOGLE_CLOUD_KEYFILE_JSON = credentials('service-account-total-control')
    }
    parameters { 
      choice(name: 'ENTORNOS', choices: ['dev', 'pre', 'pro'], description: 'Seleccione el entorno a utilizar')
      choice(name: 'ACCION', choices: ['', 'plan-apply', 'destroy'], description: 'Seleccione el entorno a utilizar')
    }
    stages{
        stage('clean workspaces -----------') { 
            steps {
              cleanWs()
              sh 'env'
            } //steps
        }  //stage

        //${params.Acción}
        stage("git clone code terraform"){
            steps {
                cleanWs()
                    checkout([$class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    doGenerateSubmoduleConfigurations: false, 
                    extensions: [[$class: 'CleanCheckout']], 
                    submoduleCfg: [], 
                    userRemoteConfigs: [
                        [url: 'https://github.com/ktonccc/gcp-terraform.git', credentialsId: '']
                        ]])
                sh 'pwd' 
                sh 'ls -l'
            } //steps
        }  //stage
    
        stage('Terraform init ') {
         steps {
            sh 'pwd'
            sh 'terraform init'
            sh 'cd /var/jenkins_home/workspace/terraformtest && ls -la' 
            sh 'cd /var/jenkins_home/workspace/terraformtest && terraform version'
            //sh 'gcloud auth login'
            //sh 'gcloud projects list'
            sh 'terraform init -var-file="dev.tfvars"'
            } //steps
        }  //stage

        stage('Terraform plan----') {
            steps {
               sh 'ls -la'
               //sh 'cd bastion && gcloud projects list'
               //sh 'terraform plan  -refresh=true  -var-file="../dev.tfvars" -lock=false'
               sh 'terraform plan  -refresh=true  -var-file=" /var/jenkins_home/workspace/terraformtest/dev.tfvars" -lock=false'

            ///var/jenkins_home/workspace/terraformtest
            } //steps
        }  //stage
        
        stage('Confirmación de accion') {
            steps {
                script {
                    def userInput = input(id: 'confirm', message: params.ACCION + '?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
                }
            }
        }
        
        stage('Terraform apply or destroy ----------------') {
            steps {
               sh 'echo "comienza"'
            script{  
                if (params.ACCION == "destroy"){
                         sh ' echo "llego" + params.ACCION'   
                         sh 'terraform destroy -var-file="../dev.tfvars" -auto-approve'
                } else {
                         sh ' echo  "llego" + params.ACCION'                 
                         sh 'terraform apply -refresh=true -var-file="../dev.tfvars"  -auto-approve'  
                }  // if

            }
            } //steps
        }  //stage
   }  // stages
} //pipeline