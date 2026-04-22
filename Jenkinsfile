pipeline {
    agent { label 'agent2' }

    environment {
        // Replace these with your actual environment values
        OS_API = 'https://api.ocprnd.comptechcloud.com:6443'
        OS_REGISTRY = 'default-route-openshift-image-registry.apps.ocprnd.comptechcloud.com'
        OS_NAMESPACE = 'bookinfo' 
        OS_CREDS = 'ocp-kubeadmin-password' // Use Jenkins Credentials Plugin
        IMAGE_NAME = 'secure-app'
        IMAGE_TAG = "v${env.BUILD_NUMBER}"
    }

    stages {
        stage('1. Build & SBOM') {
            steps {
                sh "echo 'FROM alpine:latest' > Dockerfile"
                sh "docker build -t ${IMAGE_NAME}:local ."
                sh "trivy image --format cyclonedx --output sbom.json ${IMAGE_NAME}:local"
            }
        }

        stage('2. Security Gate') {
            steps {
                sh "trivy image --format template --template '@/var/lib/jenkins/trivy-templates/html.tpl' --output scan_report.html ${IMAGE_NAME}:local"
                // Block push if CRITICAL bugs exist
                sh "trivy image --exit-code 1 --severity CRITICAL ${IMAGE_NAME}:local"
            }
        }

        stage('3. Cloud Promotion') {
            steps {
                script {
                    // Replace with your credential logic
                    sh "oc login ${OS_API} -u kubeadmin -p <YOUR_PASSWORD> --insecure-skip-tls-verify"
                    sh "docker login -u kubeadmin -p \$(oc whoami -t) ${OS_REGISTRY}"
                    sh "docker tag ${IMAGE_NAME}:local ${OS_REGISTRY}/${OS_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push ${OS_REGISTRY}/${OS_NAMESPACE}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'scan_report.html, sbom.json'
            publishHTML([
                allowMissing: false, reportDir: '.', reportFiles: 'scan_report.html', reportName: 'Security Dashboard'
            ])
        }
    }
}
