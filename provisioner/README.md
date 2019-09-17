# F5 Ansible AWS provisioner

# Table Of Contents
- [Requirements](#requirements)
- [Lab Setup](#lab-setup)
  - [One Time Setup](#one-time-setup)
  - [Accessing student documentation](#Accessing-student-documentation-and-slides)
- [Lab Teardown](#aws-teardown)
- [FAQ](../docs/faq.md)
- [More info on what is happening](#more-info-on-what-is-happening)

# Requirements
- This provisioner must be run with Ansible Engine v2.8.0 or higher.
- AWS Account (follow directions on one time setup below)

# Lab Setup

## One Time Setup
[For One Time Setup - click here](../docs/setup.md)

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

.. note::
   If the provisioning is not successful, please teardown the lab using command `ansible-playbook teardown_lab.yml -e @f5_vars.yml` and then run the provision playbook again
   
3. Login to the EC2 console and you should see instances being created like:

        `TESTWORKSHOP-studentX-ansible`

## Accessing student documentation and slides

  - Workbench information is stored in a local directory named after the workshop (e.g. TESTWORKSHOP/instructor_inventory)

# Lab Teardown

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
