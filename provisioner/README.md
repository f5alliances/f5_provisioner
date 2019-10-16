# F5 Ansible AWS provisioner

# Table Of Contents
- [F5 Ansible AWS provisioner](#f5-ansible-aws-provisioner)
- [Table Of Contents](#table-of-contents)
- [Requirements](#requirements)
- [Build Lab](#build-lab)
  - [One Time Setup](#one-time-setup)
    - [Install Ansible](#install-ansible)
    - [AWS Setup](#aws-setup)
  - [Per workshop Setup](#per-workshop-setup)
  - [Access the Lab](#access-the-lab)
- [Teardown Lab](#teardown-lab)
- [FAQ](#faq)
- [More info on what is happening](#more-info-on-what-is-happening)

# Requirements
- Ansible Engine v2.8.0 or higher.
- AWS Account

# Build Lab

## One Time Setup

### Install Ansible
1. Install Python
Install the latest version of Python (2.7 minimum) if you do not already have it.
- http://www.python.org/

2. Install Ansible
Then, install Ansible (v2.8.0 minimum):
- http://docs.ansible.com/ansible/latest/intro_installation.html

F5 recommends that you install Ansible by using virtualenv/pip. For an example, see [Install Ansible by using virtualenv](https://clouddocs.f5.com/products/orchestration/ansible/devel/usage/virtualenv.html).

### AWS Setup
1. Create an Amazon AWS account.

2. Create an Access Key ID and Secret Access Key.  Save the ID and key for later.

  - New to AWS and not sure what this step means?  [Click here](aws-directions/AWSHELP.md)

3. Install `boto` and `boto3`as well as `netaddr` and `passlib`

        pip install boto boto3 netaddr passlib

4. Set your Access Key ID and Secret Access Key from Step 2 under ~/.aws/credentials

```shell
[root@centos ~]# cat ~/.aws/credentials
[default]
aws_access_key_id = ABCDEFGHIJKLMNOP
aws_secret_access_key = ABCDEFGHIJKLMNOP/ABCDEFGHIJKLMNOP
```

5. Clone the workshops repo:

If you haven't done so already make sure you have the repo cloned to the machine executing the playbook
```bash
        git clone https://github.com/f5alliances/f5_provisioner.git
        cd workshops/provisioner
```

6.  Make sure you have subscribed to the right marketplace AMI (Amazon Machine Image). You will need the F5 BIG-IP [Click here](https://aws.amazon.com/marketplace/pp/B079C44MFH/)


## Per workshop Setup

Now you can start to provision a Lab Environment in AWS.

1. Confiure f5_vars.yml to reflect your environment under provisioning.
  ```yaml
        # region where the nodes will live
        ec2_region: us-west-2
        # name prefix for all the VMs
        ec2_name_prefix: TESTWORKSHOP1
        # amount of work benches to provision
        student_total: 1

        ## Optional Variables
        # password used for student account on control node
        admin_password: ansible

        # DO NOT CHANGE
        # workshp runs in F5 mode
        workshop_type: f5
  ```

2. Run the playbook:

        ansible-playbook provision_lab.yml -e @f5_vars.yml

> **NOTE**: 
> **If the provisioning is not successful**, please teardown the lab using command 
> `ansible-playbook teardown_lab.yml -e @f5_vars.yml` 
> and then run the provision playbook again (Step 2)
   
3. Login to the AWS EC2 console and you should see instances being created like:

        `TESTWORKSHOP1-studentX-ansible`

## Access the Lab

- Workbench information is stored in a local directory named after the workshop (e.g. TESTWORKSHOP1/instructor_inventory.txt) after the provisioner is run and is succesful. Example:
   ```
   [all:vars]
   ansible_port=22

   [student1]
   student1-ansible ansible_host=34.219.251.xxx ansible_user=centos 
   student1-f5 ansible_host=52.39.228.xxx ansible_user=admin
   student1-host1 ansible_host=52.43.153.xxx ansible_user=centos
   student1-host2 ansible_host=34.215.176.xxx ansible_user=centos
   ```
   
 - ssh to the ansible control node using studentx/ansible (x=studentID, example 1,2,3 etc.)

# Teardown Lab

The `teardown_lab.yml` playbook deletes all the sandbox instances as well as local inventory files.

To destroy all the EC2 instances after training is complete:

1. Run the playbook:

```shell
        ansible-playbook teardown_lab.yml -e @f5_vars.yml
```

# FAQ

For frequently asked questions see the [FAQ](../docs/faq.md)

# More info on what is happening

The `provision_lab.yml` playbook creates a work bench for each student, configures them for password authentication, and creates an inventory file for each user with their IPs and credentials. An instructor inventory file is also created in the current directory which will let the instructor access the nodes of any student.  This file will be called `instructor_inventory.txt`

What does the AWS provisioner take care of automatically?
- AWS VPC creation (Amazon WebServices Virtual Private Cloud)
- Creation of an SSH key pair (stored at ./WORKSHOPNAME/WORKSHOPNAME-private.pem)
- Creation of a AWS EC2 security group
- Creation of a subnet for the VPC
- Creation of an internet gateway for the VPC
- Creation of route table for VPC (for reachability from internet)

What EC2 instances does it spin up?
- One ansible control node using a Centos image
- Two webservers using a Centos image
- One BIG-IP using the BEST license (pre-licensed)

What tasks does it perfrom on the BIG-IP?
- Changes the default MGMT password