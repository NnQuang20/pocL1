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
                    sh "docker build -t nnquang12/student-app-client ."
                }
            }
        }

        stage("push-images"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'nnquang12', variable: 'nnquang12')]) {
                    sh 'docker login -u nnquang12 -p ${nnquang12}'
                    }
                    sh 'docker push nnquang12/student-app-api:0.0.1-SNAPSHOT'
                    sh 'docker push nnquang12/student-app-client:latest'
                }
            }
        }
        stage("deploy"){
            steps{
                sh 'helm upgrade nnq helm/ --install'
            }
        }
    }
}
