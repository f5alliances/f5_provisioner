# FAQ for the Provisioner
Frequently Asked Questions... or rather common problems that people have hit.

## Problem: boto3 missing

```
fatal: [localhost]: FAILED! => {"attempts": 1, "changed": false, "msg": "Python modules \"botocore\" or \"boto3\" are missing, please install both"}
```

OR

```
fatal: [localhost]: FAILED! => {"attempts": 1, "changed": false, "msg": "boto is required for this module"}
```

### Solution:

```
pip install boto boto3
```


## Problem: Unable to locate credentials

```
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: NoCredentialsError: Unable to locate credentials
fatal: [localhost]: FAILED! => {"attempts": 1, "changed": false, "msg": "Failed to describe VPCs: Unable to locate credentials"}
```

### Solution:

Set your Access Key ID and Secret Access Key under ~/.aws/credentials

```
[root@centos ~]# cat ~/.aws/credentials
[default]
aws_access_key_id = ABCDEFGHIJKLMNOP
aws_secret_access_key = ABCDEFGHIJKLMNOP/ABCDEFGHIJKLMNOP
```

## Problem: wrong version of Ansible

```
TASK [make sure we are running correct Ansible Version] ********************************
fatal: [localhost]: FAILED! => {
    "assertion": "ansible_version.minor >= 6",
    "changed": false,
    "evaluated_to": false
}
```
### Solution
Install 2.6 or later.  For Tower make sure to use an RPM.  You can download a nightly here: https://releases.ansible.com/ansible/rpm/nightly/devel/epel-7-x86_64/

## Problem: Wrong version of boto3
```
make sure we are running correct boto version
py_cmd.stdout.startswith('1.7')
```

### Solution

Install and/or upgrade boto3
```
pip install boto3 --upgrade
```

## Problem: AWS Signature Failure
```
    "error": {
        "message": "Signature expired: 20180703T083815Z is now earlier than 20180703T152801Z (20180703T154301Z - 15 min.)",
        "code": "SignatureDoesNotMatch",
        "type": "Sender"
```

### Solution

Ensure the time on your Ansile Tower or Ansible Engine Server is correct.


## Problem: F5 Workshop provisioner fails on mac

```
TASK [f5_setup : Install AS3] *******************************************************************************
fatal: [TESTWORKSHOP-student1-f5]: FAILED! => {"changed": false, "cmd": "rpm -qp --queryformat '%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}' <ommited>/workshops/provisioner/roles/f5_setup/files/f5-appsvcs-3.4.0-2.noarch.rpm", "msg": "[Errno 2] No such file or directory", "rc": 2}
```

### Solution:

```
$ brew install rpm
```
