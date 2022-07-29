pipeline{

    agent any

    stages{

        stage("git-commit"){
            steps{
                git 'https://github.com/NnQuang20/pocL1.git'
            }
        }

        stage("build-api"){
            steps{
                dir ("spring-boot-student-app-api"){
                    // Run maven on a unix agent.
                    sh "mvn package"
                }
            }
        }

        stage("build-client"){
            steps{
                dir ("react-student-management-web-app"){
                    sh "docker build -t nnquang12/student-app-client:1.1.0 ."
                }
            }
        }

        stage("push-images"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'nnquang', variable: 'nnquang12')]) {
                    sh 'docker login -u nnquang12 -p ${nnquang12}'
                    }
                    sh 'docker push nnquang12/student-app-api:0.0.1-SNAPSHOT'
                    sh 'docker push nnquang12/student-app-client:1.1.0'
                }
            }
        }
	stage("add repo"){
            steps{
                sh 'helm repo add istio https://istio-release.storage.googleapis.com/charts'
		sh 'helm repo add prometheus-community https://prometheus-community.github.io/helm-charts'
		sh 'helm repo add bitnami https://charts.bitnami.com/bitnami'
                sh 'helm repo ls'
                sh 'helm repo update'
            }
        }
        stage("install istio"){
            steps{
                dir ("gateway"){
                    //sh 'kubectl create namespace istio-system'
                    sh 'kubectl label namespace default istio-injection=enabled --overwrite'
                    sh 'helm upgrade istio-base istio/base -n istio-system --install'
                    sh 'helm upgrade istiod istio/istiod -n istio-system --wait --install'
                    sh 'helm upgrade istio-ingress istio/gateway -f nnq.yaml -n istio-system --wait --install'
                    sh 'kubectl apply -f istio-ingressgateway.yaml'
                }  
            }
        }
	stage("deploy"){
            steps{
                sh 'helm upgrade nnq helm/ --install'
            }
        }
        stage("prometheus & grafana"){
            steps{
		sh 'helm upgrade prometheus prometheus-community/prometheus --install'
                //sh 'kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-np'
                //sh 'minikube service prometheus-server-np'
                sh 'helm upgrade grafana bitnami/grafana -f value_grafana.yaml --install'
                //sh 'kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-np'
                //echo "User: admin"
                //echo "Password: $(kubectl get secret grafana-admin --namespace default -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 -d)"
                //sh 'minikube service grafana-np'
            }
        }
    }
}
