pipeline {
    agent {label "bond"}
    
    environment {
        GROQ_API_KEY = credentials("GROQ_API_KEY")
        IMAGE_NAME = "flask_chatbot"
    }
    
    stages {
        stage("Checkout") {
            steps {
                echo "Cloning the repo"
                git scm
                echo "cloned successfully"
                sh 'echo "Secret is $GROQ_API_KEY"'
            }
        }
        
        stage("build") {
            steps {
                sh '''
                echo "building and injecting env secrets"
                which docker || sudo apt update && sudo apt install -y docker.io
                which docker-compose || sudo apt update && sudo apt install -y docker-compose
                sudo systemctl enable docker && sudo systemctl start docker
                
                echo "docker ready, building image"
                sudo docker build --build-arg GROQ_API_KEY=$GROQ_API_KEY \
                -t $IMAGE_NAME:latest .
                '''
            }
        }
        
        stage("Deployment") {
            steps {
                sh '''
                echo "Deploying the container"
                
                # if sudo docker ps -a --format '{{.Names}}' | grep -qw chatbot; then
                #     echo "Stoppping the existing container"
                #     sudo docker stop chatbot
                #     echo "Removing the stopped container"
                #     sudo docker rm chatbot
                # fi
                
                PORT_CONTAINERS=$(sudo docker ps -a --filter "publish=8085" --format "{{.ID}}")

                if [ -n "$PORT_CONTAINERS" ]; then
                    echo "Stopping containers using port 8085..."
                    sudo docker stop $PORT_CONTAINERS
                    echo "Removing containers using port 8085..."
                    sudo docker rm $PORT_CONTAINERS
                fi
                    
                echo "Starting the new container"
                sudo docker run -d -p 8085:8085 \
                -e GROQ_API_KEY=$GROQ_API_KEY \
                $IMAGE_NAME:latest
                '''
            }
        }
    }
    
    post {
        success {
            echo "Pipeline deployment successful"
        }
    }
}