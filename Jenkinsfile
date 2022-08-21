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
  - name: curl
    image: curlimages/curl:7.81.0
    command:
    - cat
    tty: true
    securityContext:
      runAsUser: 0
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
                sh """helm upgrade --install --recreate-pods $APP_NAME ./helm"""
                echo "Deployed $APP_NAME succesfully to kubernetes"
            }
        }
    }
    stage('Test') {
        steps {
            container('curl') {
                script {
                    sh "sleep 10"
                    status_code = sh (
                    script: 'curl -s -o /dev/null -w %{http_code} http://$APP_NAME:4000',
                     returnStdout: true
                    ).trim()
                    if (status_code.toInteger() == 200) {
                        echo "Test succeeded, the website is up!"
                    }
                    else {
                        error("Test failed, the website is down")
                    }
                }
            }
        }
    }
  }
}