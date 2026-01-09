# Connect to EC2 with Session Manager

## Set up Systems Manager Default Host Management Configuration

If you haven't used Systems Manager before you must follow these steps:
1. Open the AWS Systems Manager console 
2. In the navigation pane, choose Fleet Manager
3. Choose Account management, Configure Default Host Management Configuration
4. Turn on Enable Default Host Management Configuration
5. Choose the IAM role used to enable Systems Manager capabilities for your instances
6. Choose Configure to complete setup

## Connect to EC2 with Session Manager

1. Navigate to "AWS Systems Manager"
2. Select "Session Manager" on the left hand navigation
3. On the "Sessions" tab click "Start session" and select an instance
4. Run some commands on the instance using session manager
5. Remove SSH from the instance's security group and validate that it doesn't break the connection

## Optional extra - Create VPC Endpoints for Private Subnets

1. Create VPC endpoints for the following endpoints:
- com.amazonaws.us-east-1.ssm
- com.amazonaws.us-east-1.ec2messages
- com.amazonaws.us-east-1.ssmmessages

2. Create an inbound rule on the security group assigned to the endpoints that allows inbound 443 (HTTPS) from the VPC CIDR
3. Use Session Manager to connect to the instances

## Optional extra - enable logging in CloudWatch Logs

1. Create an inline policy on the instance's IAM role with the code below
2. Navigate to "Amazon CloudWatch"
3. Click "Logs" and "Log groups" on the left hand navigation
4. Click "Create log group" and enter the name "session-manager-logs"
5. Click "Create"
6. Back in Session Manager click on the "Preferences" tab and click "Edit"
7. Enable CloudWatch logging and specify the log group
8. De-select "Enforce encryption" and save the settings
9. Create a new session and monitor CloudWatch Logs

***code for inline policy***

```bash
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Resource": "*"
        }
    ]
}
```