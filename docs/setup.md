# One Time Setup

Here are the setup directions you have to perform one time for the [../provisioner](provisioner).

# Table Of Contents

- [Setup](#setup)
- [Tower Instructions](#tower-instructions)

# Setup

1. Create an Amazon AWS account.

2. Create an Access Key ID and Secret Access Key.  Save the ID and key for later.

  - New to AWS and not sure what this step means?  [Click here](aws-directions/AWSHELP.md)

3. Install `boto` and `boto3`as well as `netaddr` and `passlib`

        pip install boto boto3 netaddr passlib

  **Are you using Tower?**  [Tower Instructions](#tower-instructions)

4. Set your Access Key ID and Secret Access Key from Step 2 under ~/.aws/credentials

```
[root@centos ~]# cat ~/.aws/credentials
[default]
aws_access_key_id = ABCDEFGHIJKLMNOP
aws_secret_access_key = ABCDEFGHIJKLMNOP/ABCDEFGHIJKLMNOP
```

5. Clone the workshops repo:

If you haven't done so already make sure you have the repo cloned to the machine executing the playbook

        git clone https://github.com/ansible/workshops.git
        cd workshops/provisioner

6. Make sure you have subscribed to the right marketplace AMI (Amazon Machine Image)

  - F5 BIG-IP [Click here](https://aws.amazon.com/marketplace/pp/B079C5DTBG/)

```
