pipeline {
    agent any

    environment {
        JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'
        PATH = "${JAVA_HOME}/bin:${env.PATH}"

        DOCKERHUB_CREDENTIALS = 'dockerhub-credentials'

        BACKEND_IMAGE  = 'anuragpatilcloud/backend'
        FRONTEND_IMAGE = 'anuragpatilcloud/frontend'

        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Verify Java & Maven') {
            steps {
                sh '''
                    export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
                    export PATH=$JAVA_HOME/bin:$PATH

                    echo "JAVA_HOME=$JAVA_HOME"
                    java -version
                    javac -version
                    mvn -version
                '''
            }
        }

        stage('Backend Test') {
            steps {
                dir('backend') {
                    sh '''
                        export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
                        export PATH=$JAVA_HOME/bin:$PATH

                        mvn clean test
                    '''
                }
            }
        }
          stage('SonarQube Analysis') {
                       steps {
                          dir('backend') {
                                withSonarQubeEnv('SonarQube') {
                                                       sh '''
                                                     export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
                                                     export PATH=$JAVA_HOME/bin:$PATH

                                                      mvn sonar:sonar \
                                                    -Dsonar.projectKey=student-registration-backend
                                                  '''
                }
            }
       }
    }
        stage('Frontend Build') {
            steps {
                dir('frontend') {
                    sh '''
                        node --version
                        npm --version

                        npm ci
                        npm run build
                    '''
                }
            }
        }

        stage('Build Backend Image') {
            steps {
                sh '''
                    docker build \
                        -t ${BACKEND_IMAGE}:${IMAGE_TAG} \
                        ./backend
                '''
            }
        }

        stage('Build Frontend Image') {
            steps {
                sh '''
                    docker build \
                        --build-arg VITE_API_URL=/api \
                        -t ${FRONTEND_IMAGE}:${IMAGE_TAG} \
                        ./frontend
                '''
            }
        }

        stage('Push Images') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: "${DOCKERHUB_CREDENTIALS}",
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_TOKEN'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_TOKEN" | docker login \
                            --username "$DOCKER_USER" \
                            --password-stdin

                        docker push ${BACKEND_IMAGE}:${IMAGE_TAG}
                        docker push ${FRONTEND_IMAGE}:${IMAGE_TAG}

                        docker logout
                    '''
                }
            }
        }

        stage('Update Helm Version') {
            steps {
                sh '''
                    sed -i \
                        "s/tag: \\"[^\\"]*\\"/tag: \\"${IMAGE_TAG}\\"/g" \
                        helm/student-registration/values.yaml

                    echo "Updated image tags:"
                    grep "tag:" helm/student-registration/values.yaml
                '''
            }
        }

        stage('Commit Helm Change') {
            steps {
                sh '''
                    git config user.name "Jenkins CI"
                    git config user.email "jenkins@localhost"

                    git add helm/student-registration/values.yaml

                    git commit -m \
                        "Update application images to ${IMAGE_TAG}" \
                        || echo "No changes to commit"
                '''
            }
        }

        stage('Push Helm Change') {
            steps {
                withCredentials([
                    gitUsernamePassword(
                        credentialsId: 'github-credentials',
                        gitToolName: 'Default'
                    )
                ]) {
                    sh '''
                        git push origin HEAD:main
                    '''
                }
            }
        }
    }

    post {
        always {
            sh '''
                docker logout || true
            '''
        }
    }
}
