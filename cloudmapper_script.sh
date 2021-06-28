#cloud-boothook
#! /bin/bash

aws_account_name=''
aws_account_id=''
region=''
cloudmapper_access_key=''
cloudmapper_secret_key=''

sudo yum update -y
sudo yum install docker -y
sudo yum -y install git
sudo systemctl restart docker
sudo systemctl enable docker
sudo git clone https://github.com/duo-labs/cloudmapper.git
sudo cd cloudmapper
sudo sed -i "s/urllib3==1.26.5/urllib3==1.25.10/g" requirements.txt
sudo sed -i "s/us-east-1/$aws_region/g" Dockerfile
sudo cp config.json.demo config.json
sudo sed -i "s/123456789012/$aws_account_id/g" config.json
sudo sed -i "s/demo/$aws_account_name/g" config.json
public_ip=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
sudo echo "CloudMapper can be accessed at $public_ip on port 8000"
sudo echo "Report details can be accessed on /account-data/report.html"
sudo docker build -t cloudmapper .
sudo docker run -dt \
        -e AWS_ACCESS_KEY_ID=$ACCESS_KEY \
        -e AWS_SECRET_ACCESS_KEY=$SECRET_KEY \
        -p 8000:8000 \
        --name cloudmapper \
        cloudmapper
sudo docker exec -it cloudmapper python cloudmapper.py collect --account $aws_account_name
sudo docker exec -it cloudmapper python cloudmapper.py report --account $aws_account_name
sudo docker exec -it cloudmapper python cloudmapper.py prepare --account $aws_account_name
sudo docker exec -it cloudmapper python cloudmapper.py webserver --public
