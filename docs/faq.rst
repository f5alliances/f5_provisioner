FAQ and troubleshooting
======================

Q: Tasks being run by the provisioner?
--------------------------------------

The provision_lab.yml playbook creates a work bench for each
student, configures them for password authentication, and creates an
inventory file for each user with their IP’s and credentials. An
instructor inventory file is also created in the current directory which
will let the instructor access the nodes of any student. This file will
be called ``instructor_inventory.txt``

Q:What gets creatd on AWS 
-------------------------

- AWS VPC creation (Amazon Web Services Virtual Private Cloud) 
- Creation of an SSH key pair (stored at ./WORKSHOPNAME/WORKSHOPNAME-private.pem) 
- Creation of a AWS EC2 security group - Creation of a subnet for the VPC
- Creation of an internet gateway for the VPC - Creation of route table for VPC (for reachability from internet)

Q: What EC2 instances does provisioner spin up
----------------------------------------------

- One ansible control node using a Centos image 
- Two webservers using a Centos image 
- One BIG-IP using the BEST license (pre-licensed)

Q. What tasks does provisioner perfrom on the BIG-IP

- Changes the default MGMT password

Problem: boto3 missing
----------------------

.. code::

   fatal: [localhost]: FAILED! => {"attempts": 1, "changed": false, "msg": "Python modules \"botocore\" or \"boto3\" are missing, please install both"}

OR

.. code::

   fatal: [localhost]: FAILED! => {"attempts": 1, "changed": false, "msg": "boto is required for this module"}

**Solution**

.. code::

   pip install boto boto3

Problem: Unable to locate credentials
-------------------------------------

.. code::

   An exception occurred during task execution. To see the full traceback, use -vvv. The error was: NoCredentialsError: Unable to locate credentials
   fatal: [localhost]: FAILED! => {"attempts": 1, "changed": false, "msg": "Failed to describe VPCs: Unable to locate credentials"}

**Solution**


Set your Access Key ID and Secret Access Key under ~/.aws/credentials

.. code ::

   [root@centos ~]# cat ~/.aws/credentials
   [default]
   aws_access_key_id = ABCDEFGHIJKLMNOP
   aws_secret_access_key = ABCDEFGHIJKLMNOP/ABCDEFGHIJKLMNOP

Problem: wrong version of Ansible
---------------------------------

.. code::

   TASK [make sure we are running correct Ansible Version] ********************************
   fatal: [localhost]: FAILED! => {
       "assertion": "ansible_version.minor >= 6",
       "changed": false,
       "evaluated_to": false
   }

**Solution**

Install 2.8 or later. 

Problem: Wrong version of boto3
-------------------------------

.. code::

   make sure we are running correct boto version
   py_cmd.stdout.startswith('1.7')


**Solution**


Install and/or upgrade boto3

.. code::

   pip install boto3 --upgrade

Problem: AWS Signature Failure
------------------------------

.. code::

   "error": {
      "message": "Signature expired: 20180703T083815Z is now earlier than 20180703T152801Z (20180703T154301Z - 15 min.)",
      "code": "SignatureDoesNotMatch",
      "type": "Sender"

**Solution**

Ensure the time on your Ansible Tower 

Problem: F5 Workshop provisioner fails on mac
---------------------------------------------

.. code::

   TASK [f5_setup : Install AS3] *******************************************************************************
   fatal: [TESTWORKSHOP-student1-f5]: FAILED! => {"changed": false, "cmd": "rpm -qp --queryformat '%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}' <ommited>/workshops/provisioner/roles/f5_setup/files/f5-appsvcs-3.4.0-2.noarch.rpm", "msg": "[Errno 2] No such file or directory", "rc": 2}


**Solution**

.. code::

   $ brew install rpm