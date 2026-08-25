pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-2'

        ECR_BACKEND_REPOSITORY  = 'node-ecs-backend'
        ECR_FRONTEND_REPOSITORY = 'node-ecs-frontend'

        ECS_CLUSTER          = 'node-cluster'
        ECS_BACKEND_SERVICE  = 'node-ecs-backend-service'
        ECS_FRONTEND_SERVICE = 'node-ecs-frontend-service'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Test Backend') {
            steps {
                dir('backend') {
                    sh 'npm ci'
                    sh 'npm test --if-present'
                }
            }
        }

        stage('Test Frontend') {
            steps {
                dir('frontend') {
                    sh 'npm ci'
                    sh 'npm test --if-present'
                }
            }
        }

        stage('Authenticate to ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region $AWS_REGION | \
                    docker login \
                    --username AWS \
                    --password-stdin \
                    $(aws sts get-caller-identity --query Account --output text).dkr.ecr.$AWS_REGION.amazonaws.com
                '''
            }
        }

        stage('Build Backend Image') {
            steps {
                sh '''
                    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

                    docker build \
                        -t $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_BACKEND_REPOSITORY:$BUILD_NUMBER \
                        -t $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_BACKEND_REPOSITORY:latest \
                        ./backend
                '''
            }
        }

        stage('Build Frontend Image') {
            steps {
                sh '''
                    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

                    docker build \
                        -t $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_FRONTEND_REPOSITORY:$BUILD_NUMBER \
                        -t $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_FRONTEND_REPOSITORY:latest \
                        ./frontend
                '''
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh '''
                    ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

                    docker push \
                        $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_BACKEND_REPOSITORY:$BUILD_NUMBER

                    docker push \
                        $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_BACKEND_REPOSITORY:latest

                    docker push \
                        $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_FRONTEND_REPOSITORY:$BUILD_NUMBER

                    docker push \
                        $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_FRONTEND_REPOSITORY:latest
                '''
            }
        }

        stage('Deploy to ECS') {
            steps {
                sh '''
                    aws ecs update-service \
                        --cluster $ECS_CLUSTER \
                        --service $ECS_BACKEND_SERVICE \
                        --force-new-deployment \
                        --region $AWS_REGION

                    aws ecs update-service \
                        --cluster $ECS_CLUSTER \
                        --service $ECS_FRONTEND_SERVICE \
                        --force-new-deployment \
                        --region $AWS_REGION
                '''
            }
        }

        stage('Wait for ECS Services') {
            steps {
                sh '''
                    aws ecs wait services-stable \
                        --cluster $ECS_CLUSTER \
                        --services $ECS_BACKEND_SERVICE \
                        --region $AWS_REGION

                    aws ecs wait services-stable \
                        --cluster $ECS_CLUSTER \
                        --services $ECS_FRONTEND_SERVICE \
                        --region $AWS_REGION
                '''
            }
        }
    }

    post {
        success {
            echo 'Jenkins pipeline completed successfully. Backend and frontend deployed to ECS.'
        }

        failure {
            echo 'Jenkins pipeline failed. Check the stage logs for details.'
        }

        always {
            sh 'docker image prune -f || true'
        }
    }
}