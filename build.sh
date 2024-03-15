aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 590183756378.dkr.ecr.us-east-1.amazonaws.com
docker build -t lab-repo .
docker tag lab-repo:latest 590183756378.dkr.ecr.us-east-1.amazonaws.com/lab-repo:latest
docker push 590183756378.dkr.ecr.us-east-1.amazonaws.com/lab-repo:latest