# Create a role in Account B with an external ID in the trust policy

***The following tasks should be executed in ACCOUNT B (DCT-PRODUCTION in the video)***

Before starting make sure you have a bucket in Account B with some objects in it.

1. In AWS CloudShell create a file named 'trust-policy.json' with the following JSON (update the account ID):
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::ACCOUNT_A_ID:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "XX9812DDF2V"
        }
      }
    }
  ]
}
```
2. Create the role
```bash
aws iam create-role \
  --role-name S3AccessRoleForExternalAccount \
  --assume-role-policy-document file://trust-policy.json
```
3. Attach the S3 full access policy
```bash
aws iam attach-role-policy \
  --role-name S3AccessRoleForExternalAccount \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess
```

# Create a test user and assume the role in Account B

***The following tasks should be executed in ACCOUNT A (DCT-MANAGEMENT in the video)***

1. In AWS CloudShell create a file named 'jack-s3.json' with the following JSON:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:ListRoles",
                "sts:AssumeRole"
            ],
            "Resource": "*"
        }
    ]
}
```
2. Create user
```bash
aws iam create-user --user-name jack
```
3. Create policy
```bash
aws iam create-policy --policy-name jack-s3 --policy-document file://jack-s3.json
```
4. Attach policy (update the account ID)
```bash
aws iam attach-user-policy --user-name jack --policy-arn "arn:aws:iam::ACCOUNT_A_ID:policy/jack-s3"
```
5. List policies attached to Jack
```bash
aws iam list-attached-user-policies --user-name jack
```
6. Create access keys and record access keys for later use
```bash
aws iam create-access-key --user-name jack
```
7. Configure CLI with profile for Jack
```bash
aws configure --profile jack
```
8. Shows the identity being used to execute commands (without any profile)
```bash
aws sts get-caller-identity
```
9. Assume the role in Account B with external ID (update the account ID)
```bash
aws sts assume-role --profile jack --role-arn "arn:aws:iam::ACCOUNT_B_ID:role/S3AccessRoleForExternalAccount" --role-session-name AWSCLI-Session --external-id XX9812DDF2V
```
10. Configure access key ID, secret access key and session token as environment variables
```bash
export AWS_ACCESS_KEY_ID=RoleAccessKeyID
export AWS_SECRET_ACCESS_KEY=RoleSecretKey
export AWS_SESSION_TOKEN=RoleSessionToken
```
11. The following command shows that we're now executing commands as the assumed role
```bash
aws sts get-caller-identity
```
12. Run S3 commands to list bucket, make bucket, and delete bucket
```bash
aws s3 ls
aws s3 mb s3://test-create-bucket-account-b-e32e090290d
aws s3 rb s3://test-create-bucket-account-b-e32e090290d
```
13. Remove environment variables
```bash
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
```
14. Show that we are now executing commands as our Admin user again
```bash
aws sts get-caller-identity
```