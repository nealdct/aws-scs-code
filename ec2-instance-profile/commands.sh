# Step 1 - if you didn't do the previous lab, run these commands, otherwise go to step 2
# Create user
aws iam create-user --user-name jack
# Create access keys and record access keys for later use
aws iam create-access-key --user-name jack
# Configure CLI with profile for Jack
aws configure --profile jack

# Step 2 - Execute commands using your own Admin account
# Create policy
aws iam create-policy --policy-name jack-ec2 --policy-document file://jack-ec2.json
# Attach policy
aws iam attach-user-policy --user-name jack --policy-arn "arn:aws:iam::ACCOUNT_A_ID:policy/jack-ec2"
# List policies attached to Jack
aws iam list-attached-user-policies --user-name jack

# Step 3 - Now we start using Jack's profile to execute commands
# Create instance profile
aws iam create-instance-profile --instance-profile-name mytestinstanceprofile --profile jack
# Add role to instance profile
aws iam add-role-to-instance-profile --role-name S3ReadOnly --instance-profile-name mytestinstanceprofile --profile jack
# Associate instance profile with EC2 instance
aws ec2 associate-iam-instance-profile --instance-id YOUR_EC2_INSTANCE_ID --iam-instance-profile Name=mytestinstanceprofile --profile jack

# Step 4 Cleanup (optional)
# Remove role from instance profile
aws iam remove-role-from-instance-profile --role-name S3ReadOnly --instance-profile-name mytestinstanceprofile --profile jack
# Delete instance profile
aws iam delete-instance-profile --instance-profile-name mytestinstanceprofile --profile jack