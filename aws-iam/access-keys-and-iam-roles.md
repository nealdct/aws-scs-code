# Using access keys and IAM roles with Amazon EC2
## Ensure that you are connecting to the US-East-1 region

# Exercise 1: Using access keys with EC2

## 1. Create Access Keys in CloudShell

Run the following command in AWS CloudShell:

```bash
aws iam create-access-key
```

You'll get output like this:

```json
{
    "AccessKey": {
        "AccessKeyId": "AKIAxxxxxxxxxxxxxxxx",
        "SecretAccessKey": "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    }
}
```

**Copy and save both keys.** You'll paste them into the EC2 instance soon.

---

## 2. Launch an EC2 Instance

In CloudShell, run (update the AMI ID):

```bash
aws ec2 run-instances \
  --image-id ami-05ffe3c48a9991133 \
  --instance-type t2.micro \
  --region us-east-1
```

## 3. Configure AWS CLI on the EC2 Instance

Use EC2 Instance Connect to connect to the instnace and in the EC2 terminal run:

```bash
aws configure
```

Enter:

* **Access Key ID**: (from CloudShell step)
* **Secret Access Key**: (from CloudShell step)
* **Region**: `us-east-1` (or whatever you used)
* **Output format**: `json`

## 5. Run AWS CLI Commands

You can now test access with:

```bash
aws sts get-caller-identity
```

Should return your IAM user identity.

List S3 buckets (if you have permission):

```bash
aws s3 ls
```

## 6. Show That Access Keys Are Stored in Plaintext

Run:

```bash
cat ~/.aws/credentials
```

You'll see:

```bash
[default]
aws_access_key_id = AKIAxxxxxxxxxxxxxx
aws_secret_access_key = xxxxxxxxxxxxxxxxxxx
```

* The AWS CLI stores credentials **in plaintext**
* These credentials can be stolen if an instance is compromised

## 7. Delete the access keys

Run the following command to delete ALL access keys from the instance:

```bash
rm -rf ~/.aws/credentials
```

Run the following commands to validate credentials are lost:

```bash
aws s3 ls
aws sts get-caller-identity
```

# Exercise 2: Create IAM Role for EC2

1. Create an IAM role with a trust policy that uses the EC2 use case
2. Attach the 'AmazonS3FullAccess' permissions policy
3. Name the role 'sts-assumerole-test'

## 1. Launch instance and assume role

### 1a. Create a Security Group

1. Create a security group
```bash
aws ec2 create-security-group --group-name IAMRoleLab --description "Temporary SG for the IAM Labs"
```
2. Add a rule for SSH inbound to the security group
```bash
aws ec2 authorize-security-group-ingress --group-name IAMRoleLab --protocol tcp --port 22 --cidr 0.0.0.0/0
```

### 1b. Launch Instance

1. Launch EC2 instance
```bash
aws ec2 run-instances --instance-type t2.micro --image-id ami-0440d3b780d96b29d --region us-east-1 --security-group-ids <SECURITY-GROUP-ID>
```
2. Describe EC2 instance
```bash
aws ec2 describe-instances --instance-ids <INSTANCE-ID>
```

### 2. Create and Attach an Instance Profile

3. Create instance profile
```bash
aws iam create-instance-profile --instance-profile-name s3-instance-profile
```
4. Add role to instance profile
```bash
aws iam add-role-to-instance-profile --role-name sts-assumerole-test --instance-profile-name s3-instance-profile
```
5. Connect to EC2 Instance Connect and run the same S3 test commands as earlier. They should fail
6. Attach instance profile to EC2 instance
```bash
aws ec2 associate-iam-instance-profile --iam-instance-profile Name=s3-instance-profile --instance-id <INSTANCE-ID>
```
7. Using EC2 instance connect, run the same S3 test commands as earlier. They should now work successfully

## 3. Cleanup

6. Terminate EC2 instance
```bash
aws ec2 terminate-instances --instance-ids <INSTANCE-ID>
```
7. Remove role from instance profile
```bash
aws iam remove-role-from-instance-profile --role-name sts-assumerole-test --instance-profile-name s3-instance-profile
```
8. Delete instance profile
```bash
aws iam delete-instance-profile --instance-profile-name s3-instance-profile
```