# Policy Statement for KMS key "kms-key-ebs-rds"

```json
{
    "Version": "2012-10-17",
    "Id": "KMSKeyPolicy",
    "Statement": [
        {
            "Sid": "Allow access for Key Administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::111122223333:user/User"
            },
            "Action": [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:UntagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "RestrictKeyUsageToEC2andRDS",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::111122223333:user/User"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:DescribeKey"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": [
                        "ec2.us-east-1.amazonaws.com",
                        "rds.us-east-1.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
```
# Policy Statement for Cross Account copy

```json
{
    "Sid": "Allow use of the key with destination account",
    "Effect": "Allow",
    "Principal": {
        "AWS": "arn:aws:iam::TARGET-ACCOUNT-ID:role/ROLENAME"
    },
    "Action": [
        "kms:Decrypt",
        "kms:CreateGrant"
    ],
    "Resource": "*",
    "Condition": {
        "StringEquals": {
            "kms:ViaService": "ec2.REGION.amazonaws.com",
            "kms:CallerAccount": "TARGET-ACCOUNT-ID"
        }
    }
}
```

