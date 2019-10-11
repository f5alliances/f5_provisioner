# F5 Ansible AWS provisioner

# Table Of Contents
- [F5 Ansible AWS provisioner](#f5-ansible-aws-provisioner)
- [Table Of Contents](#table-of-contents)
- [Requirements](#requirements)
- [Build Lab](#build-lab)
  - [One Time Setup](#one-time-setup)
    - [Tower Instructions](#tower-instructions)
  - [Per workshop Setup](#per-workshop-setup)
  - [Accessing student documentation and slides](#accessing-student-documentation-and-slides)
- [Teardown Lab](#teardown-lab)
- [FAQ](#faq)
- [More info on what is happening](#more-info-on-what-is-happening)

# Requirements
- This provisioner must be run with Ansible Engine v2.8.0 or higher.
- AWS Account (follow directions on one time setup below)

# Build Lab

## One Time Setup
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

6.  Make sure you have subscribed to the right marketplace AMI (Amazon Machine Image). You will need the F5 BIG-IP [Click here](https://aws.amazon.com/marketplace/pp/B079C44MFH/)

### Tower Instructions

Are you using Red Hat Ansible Tower to provision Ansible Automation Workshops? (e.g. is your control node Ansible Tower?)  Make sure to use umask for the installation of boto3 on the control node.
https://docs.ansible.com/ansible-tower/latest/html/upgrade-migration-guide/virtualenv.html

```
[user@centos ~]$ sudo -i
[root@centos ~]# source /var/lib/awx/venv/ansible/bin/activate
[root@centos ~]# umask 0022
[root@centos ~]# pip install --upgrade boto3
[root@centos ~]# deactivate
```

## Per workshop Setup
1. Change the f5_vars.yml to reflect for your environment

        # region where the nodes will live
        ec2_region: us-west-2

        # name prefix for all the VMs
        ec2_name_prefix: TESTWORKSHOP

        # amount of work benches to provision
        student_total: 1

        #DO NOT CHANGE
        # workshp runs in F5 mode
        workshop_type: f5

2. Run the playbook:

        ansible-playbook provision_lab.yml -e @f5_vars.yml

NOTE::

        If the provisioning is not successful, please teardown the lab using command 
        `ansible-playbook teardown_lab.yml -e @f5_vars.yml` 
        and then run the provision playbook again (Step 2)
   
3. Login to the EC2 console and you should see instances being created like:

        `TESTWORKSHOP-studentX-ansible`

## Accessing student documentation and slides

  - Workbench information is stored in a local directory named after the workshop (e.g. TESTWORKSHOP/instructor_inventory)

# Teardown Lab

The `teardown_lab.yml` playbook deletes all the training instances as well as local inventory files.

To destroy all the EC2 instances after training is complete:

1. Run the playbook:

        ansible-playbook teardown_lab.yml -e @f5_vars.yml

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
- One BIG-IP using the BEST licesnse (pre-licensed)

What tasks does it perfrom on the BIG-IP?
- Changes the default MGMT password
- Installs the AS3 RPM
