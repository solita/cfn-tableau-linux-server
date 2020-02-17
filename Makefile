AWS_PROFILE=default
REGION=eu-west-1
SERVICE_NAME=linux-tableau-server

PASSWORD=$(shell python3.6 -c "import random, string; print(''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(50)))")


deploy-tableau: generate-params
	aws cloudformation create-stack \
		--stack-name tableau-server-linux \
		--parameters file://tmp.json \
		--template-body file://cfn-tableau-server-linux.yaml \
		--profile=${AWS_PROFILE} \
		--region=${REGION}	\
		--capabilities CAPABILITY_NAMED_IAM
	rm tmp.json
	

get-newest-image:
	aws ec2 describe-images \
		--profile ${AWS_PROFILE} \
		--region ${REGION} \
		--filter Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-xenial-*-amd64-server-* \
		--query Images[*].[Name,ImageId] --output text \
		| sort -t \t -rk1 | awk '{print $$2}' | head -n 1


generate-params:
	@sed -e "s/AMI_REPLACE/$(shell aws ec2 describe-images \
								--profile ${AWS_PROFILE} \
								--region ${REGION} \
								--filter Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-xenial-*-amd64-server-* \
								--query Images[*].[Name,ImageId] --output text \
								| sort -t \t -rk1 | awk '{print $$2}' | head -n 1)/g" \
		-e "s/PASSWORD_REPLACE/${PASSWORD}/g" \
		parameters.json > tmp.json
