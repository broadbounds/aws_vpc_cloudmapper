#! /bin/bash
			
			aws_account_name = BroadBounds
			aws_account_id = 003802458846
			aws_region = us-east-2
			ACCESS_KEY = AKIAQBYVE5LPAHY3JHVB
			SECRET_KEY = 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
			
            yum update -y
            yum install docker -y
			yum -y install git
            systemctl restart docker
            systemctl enable docker
			cd cloudmapper/
			sed -i "s/urllib3==1.26.5/urllib3==1.25.10/g" requirements.txt
			sed -i "s/us-east-1/$aws_region/g" Dockerfile
			cp config.json.demo config.json
			sed -i "s/123456789012/$aws_account_id/g" config.json
			sed -i "s/demo/$aws_account_name/g" config.json
			docker build -t cloudmapper .
			sudo docker run -ti \
				-e AWS_ACCESS_KEY_ID=$ACCESS_KEY \
				-e AWS_SECRET_ACCESS_KEY=$SECRET_KEY \
				-p 8000:8000 \
				cloudmapper /bin/bash
			python cloudmapper.py collect --account $aws_account_name
			python cloudmapper.py report --account $aws_account_name
			python cloudmapper.py prepare --account $aws_account_name
			python cloudmapper.py webserver --public
			public_ip='curl http://169.254.169.254/latest/meta-data/public-ipv4'
			echo "CloudMapper can be accessed at $public_ip on port 8000"
			echo "Report details can be accessed on /account-data/report.html"
