# Connect with Key Pairs and SSH

## Create a custom VPC
1. Create a VPC choosing the "VPC and more" option
2. Provide a name for the VPC, e.g. ssh-lab
3. No NAT Gateway or S3 Gateway
4. Use defaults for other selections
5. Modify the public subnets to auto assign IPv4 addresses

## Launch instances and connect
1. Launch one instance in a public subnet and one in a private subnet
2. Ensure you attach a key pair you have access to or create one
3. Attach a security group allowing SSH inbound from anywhere
4. Open the private key file with a notepad app on your computer
5. Copy the contents of the private key and paste into a file of the same name on the public instance
6. Run the command `chmod 400 <filename>`to update the permissions
7. Establish a connection to the private instance using the following command:

`ssh -i <filename> ec2-user@<ip-address>`