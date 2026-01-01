# Launch Instances from the AWS CLI

1. Launch with the minimum required information

```bash
aws ec2 run-instances --image-id <LATEST-AMI-ID> --instance-type t2.micro
```
2. Specify the number of instances

```bash
aws ec2 run-instances --image-id <LATEST-AMI-ID> --count 2 --instance-type t2.micro
```

3. Specify a security group and subnet

```bash
aws ec2 run-instances --image-id <LATEST-AMI-ID> --instance-type t2.micro --security-group-ids <SECURITY-GROUP-ID> --subnet-id <SUBNET-ID>
```

4. Specify an IAM role

```bash
aws ec2 run-instances --image-id <LATEST-AMI-ID> --instance-type t2.micro --iam-instance-profile Name=<IAM-ROLE-NAME>
```

5. Terminating EC2 instances

```bash
aws ec2 terminate-instances --instance-ids <INSTANCE-ID-1> <INSTANCE-ID-2>