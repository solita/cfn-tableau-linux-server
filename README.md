# Cloudformation for tableau using linux on EC2
This cloudformation templates simplifies deployment of tableau server on AWS using EC2.

This template is based on the tableau server aws quickstart template with some added features, such as:
1. Automatic creation of maintenance job that exports tableau logs, settings, and database to a S3 bucket. By default it runs at 00:00 every day.
2. Password generation and handling for tableau server management agent.
3. Creation of roles required. 
4. Automatically using the newest AMI for specified region (if deploying via Makefile).
5. Automatic installation of latest Snowflake ODBC driver on creation.


## How to use
#### Using makefile
1. Edit the parameters.json file with the parameters of your stack. Descriptions of the parameters can be found in *cfn-tableau-server.yaml*
	- Leaving Password as PASSWORD_REPLACE will generate a password and put it in ssm.
	Leaving AMIId as AMI_REPLACE will select the newest version available.
2. Edit AWS_REGION and AWS_PROFILE parameters in Makefile.
3. Run *make deploy-tableau*

#### Using AWS console 
1. Use create stack command in AWS console and upload the template following instructions in console.
	- Leaving the parameter AMIID as the default value FindInMapping will use hard-coded values for the AMIId which will probably not be the newest image. Use *get-newest-image* in the Makefile to get the most recent ID.