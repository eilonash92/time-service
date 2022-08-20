pipeline {
  agent {
    kubernetes {
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  containers:
  - name: docker
    image: docker:latest
    command:
    - cat
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-sock
  - name: helm
    image: lachlanevenson/k8s-helm:v3.1.1
    command:
    - cat
    tty: true
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
  
"""
}
   }
    environment {
        DOCKER_HUB_REPO = "eilonash92/time-service"
        USER_NAME="eilonash92"
        APP_NAME = "time-service"
    }
  stages {
    stage('Build') {
      steps {
        container('docker') {
          //  Building Image
          sh """docker build -t $DOCKER_HUB_REPO:$BUILD_NUMBER -t $DOCKER_HUB_REPO:latest ."""
          //  Pushing Image to Dockerhub Repository
          echo "Image built and pushed to repository"
          withDockerRegistry([ credentialsId: "docker-hub-credentials", url: "" ]) {
                sh """docker push $DOCKER_HUB_REPO:$BUILD_NUMBER"""
          }
          withDockerRegistry([ credentialsId: "docker-hub-credentials", url: "" ]) {
                sh """docker push $DOCKER_HUB_REPO:latest"""
          }
        }
      }
    }
    stage('Deploy') {
        steps {
            container('helm') {
                sh """helm upgrade --install $APP_NAME ./helm"""
                echo "Deployed $APP_NAME succesfully to kubernetes"
            }
        }
    }
    stage('Test') {
        steps {
            script {
                    def status_code = "curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:5000"
                    if status_code.contains("200") {
                        error("Test succeeded, the website is up")
                    }
                    else {
                        error("Test failed, the website is down")
                    }
                }
        }
    }
  }
}