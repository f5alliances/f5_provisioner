# F5 Ansible AWS provisioner

# Table Of Contents
- [F5 Ansible AWS provisioner](#f5-ansible-aws-provisioner)
- [Table Of Contents](#table-of-contents)
- [PRE-REQUISITES](#pre-requisites)
- [BUILD LAB](#build-lab)
  - [One Time Setup](#one-time-setup)
    - [Install Ansible](#install-ansible)
    - [AWS Setup](#aws-setup)
  - [Per workshop Setup](#per-workshop-setup)
  - [Access the Lab](#access-the-lab)
  - [Get Started with an exmaple](#get-started-with-an-exmaple)
- [TEAR DOWN LAB](#tear-down-lab)
- [FAQ](#faq)
- [More info on what is happening](#more-info-on-what-is-happening)

# PRE-REQUISITES
This provisioner is run using Ansible on AWS. To run the provisioner you will need the following
- Server from where the provisioner will be executed installed with Ansible Engine v2.8.0 or higher. Let's give the server a name which we will refer in the rest of the document (**ansible_server_provisioner**)
- An account on [AWS](https://aws.amazon.com/)

# BUILD LAB

## One Time Setup 

Following needs to be installed on the **ansible_server_provioner**

### Install Ansible
1. Install Python - latest version of Python (2.7 minimum) if you do not already have it.
   - http://www.python.org/

2. Install Ansible version 2.8.0 minimum:
   - http://docs.ansible.com/ansible/latest/intro_installation.html

If you run Ansible by using virtualenv/pip, please refer to [Install Ansible by using virtualenv](https://clouddocs.f5.com/products/orchestration/ansible/devel/usage/virtualenv.html).

After installation run the following command to verify ansible installation

```shell
# ansible --version
ansible 2.8.5
  config file = None
  configured module search path = ['/Users/test/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /Users/test/myansible/lib/python3.7/site-packages/ansible
  executable location = /Users/test/myansible/bin/ansible
  python version = 3.7.3 (default, Jun 19 2019, 07:40:11) [Clang 9.0.0 (clang-900.0.39.2)]
```

### AWS Setup
1. Create an Amazon AWS account.

2. Create an Access Key ID and Secret Access Key.  Save the ID and key for later.
   - New to AWS and not sure what this step means?  [Click here](aws-directions/AWSHELP.md)

3. Install `boto` and `boto3`as well as `netaddr` and `passlib` on the **ansible_server_provisioner**

       pip install boto boto3 netaddr passlib

4. Set your Access Key ID and Secret Access Key from Step 2 under ~/.aws/credentials in the **ansible_server_provisioner**

       [root@centos ~]# cat ~/.aws/credentials
       [default]
       aws_access_key_id = ABCDEFGHIJKLMNOP
       aws_secret_access_key = ABCDEFGHIJKLMNOP/ABCDEFGHIJKLMNOP

5. Clone the workshops repo on the ansible_server_provisioner

       git clone https://github.com/f5alliances/f5_provisioner.git
       cd f5_provisioner/provisioner

6. Make sure you have subscribed to the right marketplace AMI (Amazon Machine Image). 
   - You will need the F5 BIG-IP [Click here](https://aws.amazon.com/marketplace/pp/B079C44MFH/)

## Per workshop Setup

Now you can start to provision a Lab Environment in AWS.

1. Configure f5_vars.yml to reflect your environment under provisioning.

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

> :warning:
> **If the provisioning is not successful**, please teardown the lab using command 
> `ansible-playbook teardown_lab.yml -e @f5_vars.yml` 
>  and then run the provision playbook again (Step 2)
 
3. Login to the AWS EC2 console and you should see instances being created like:

        `TESTWORKSHOP1-studentX-ansible`

![Provisioner](../images/provisioner.gif)

> :warning: 
> Remember to tear down the lab when not is use by following [TEAR DOWN LAB](#tear-down-lab), to avoid unexpected AWS charges!

## Access the Lab

Workbench information is stored in a local directory named after the workshop (e.g. TESTWORKSHOP1/instructor_inventory.txt) after the provisioner is run and is succesful. Example:

   ```handlebars
   [all:vars]
   ansible_port=22

   [student1]
   student1-ansible ansible_host=34.219.251.xxx ansible_user=centos 
   student1-f5 ansible_host=52.39.228.xxx ansible_user=admin
   student1-host1 ansible_host=52.43.153.xxx ansible_user=centos
   student1-host2 ansible_host=34.215.176.xxx ansible_user=centos
   ```
   
 - ssh to the ansible control node using studentx/ansible (x=studentID, example 1,2,3 etc.)

## Get Started with an exmaple
1. Login to Ansible control node using the studentID and the password mentioned in the f5_vars.yml earlier

```
ssh student1@34.219.251.xxx
student1@34.219.251.xxx's password:
Last login: Mon Oct 28 18:07:53 2019 from 

```

2. Run the `ansible` command with the `--version` command to look at what is configured:

```
[student1@ansible networking-workshop]$ ansible --version
ansible 2.8.5
  config file = /home/student1/.ansible.cfg
  configured module search path = [u'/home/student1/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.5 (default, Oct 30 2018, 23:45:53) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]
```

3. Use the cat command to view the contents of your inventory

```
[student1@ansible ~]$ cd networking-workshop/
[student1@ansible networking-workshop]$ cat lab_inventory/hosts
```
The output will look as follows with student1 being the respective student workbench:
```
[all:vars]
ansible_user=studentx
ansible_ssh_pass=<password_from_file>
ansible_port=22

[lb]
f5 ansible_host=34.199.128.69 ansible_user=admin private_ip=172.16.26.136 ansible_ssh_pass=<password_from_file>

[control]
ansible ansible_host=107.23.192.217 ansible_user=ec2-user private_ip=172.16.207.49

[webservers]
host1 ansible_host=107.22.141.4 ansible_user=ec2-user private_ip=172.16.170.190
host2 ansible_host=54.146.162.192 ansible_user=ec2-user private_ip=172.16.160.13
```

4. Using your text editor of choice create a new file called `bigip-facts.yml` in the home directory `/home/studentx`

The BIG-IP input values are taken from the inventory file mentioned earlier

```yaml
---
- name: GRAB F5 FACTS
  hosts: f5
  connection: local
  gather_facts: no

  tasks:
    - name: Set a fact named 'provider' with BIG-IP login information
      set_fact:
       provider:
        server: "{{private_ip}}"
        user: "{{ansible_user}}"
        password: "{{ansible_ssh_pass}}"
        server_port: 8443
        validate_certs: no

    - name: COLLECT BIG-IP FACTS
      bigip_device_facts:
        provider: "{{provider}}"
        gather_subset:
         - system-info
      register: device_facts
      
    - name: DISPLAY COMPLETE BIG-IP SYSTEM INFORMATION
      debug:
        var: device_facts

    - name: DISPLAY ONLY THE MAC ADDRESS
      debug:
        var: device_facts['system_info']['base_mac_address']

    - name: DISPLAY ONLY THE VERSION
      debug:
        var: device_facts['system_info']['product_version']
```
5. Run the playbook - exit back into the command line of the control host and execute the following:

```bash
[student1@ansible ~]$ ansible-playbook bigip-facts.yml
```

6. The output will look as follows.

```
[student1@ansible ~]$ ansible-playbook bigip-facts.yml

PLAY [GRAB F5 FACTS] 
****************************************************************
TASK [Set a fact named 'provider' with BIG-IP login information] 
****************************************************************
ok: [f5]

TASK [COLLECT BIG-IP FACTS] 
****************************************************************
changed: [f5]

TASK [DISPLAY COMPLETE BIG-IP SYSTEM INFORMATION] 
****************************************************************

ok: [f5] =>
  device_facts:
    ansible_facts:
      discovered_interpreter_python: /usr/bin/python
    changed: true
    failed: false

    system_info:
      base_mac_address: 02:f1:92:e9:a2:38
      chassis_serial: 4eae2aec-f538-c80b-b48ce7466d8f
      hardware_information:
      - model: Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz
        name: cpus
        type: base-board
        versions:
        - name: cpu stepping
          version: '1'
        - name: cpu sockets
          version: '1'
        - name: cpu MHz
          version: '2294.944'
        - name: cores
          version: 2  (physical:2)
        - name: cache size
          version: 46080 KB
      marketing_name: BIG-IP Virtual Edition
      package_edition: Point Release 7
      package_version: Build 0.0.1 - Tue May 15 15:26:30 PDT 2018
      platform: Z100
      product_build: 0.0.1
      product_build_date: Tue May 15 15:26:30 PDT 2018
      product_built: 180515152630
      product_changelist: 2557198
      product_code: BIG-IP
      product_jobid: 1012030
      product_version: 13.1.0.7
      time:
        day: 28
        hour: 18
        minute: 38
        month: 10
        second: 42
        year: 2019
      uptime: 8196900.0

TASK [DISPLAY ONLY THE MAC ADDRESS] 
****************************************************************
ok: [f5] =>
  device_facts['system_info']['base_mac_address']: 02:f1:92:e9:a2:38

TASK [DISPLAY ONLY THE VERSION] 
****************************************************************
ok: [f5] =>
  device_facts['system_info']['product_version']: 13.1.0.7

PLAY RECAP 
****************************************************************
f5                         : ok=4    changed=1    unreachable=0    failed=0

```

Congratulations, your lab is up and running!

# TEAR DOWN LAB

The `teardown_lab.yml` playbook deletes all the sandbox instances as well as local inventory files.

To destroy all the EC2 instances after training is complete:

1. Run the playbook:

```shell
        ansible-playbook teardown_lab.yml -e @f5_vars.yml
```

# FAQ

For frequently asked questions see the [FAQ](../docs/faq.md)

# More info on what is happening

The `provision_lab.yml` playbook creates a work bench for each student, configures them for password authentication, and creates an inventory file for each user with their IP's and credentials. An instructor inventory file is also created in the current directory which will let the instructor access the nodes of any student.  This file will be called `instructor_inventory.txt`

What does the AWS provisioner take care of automatically?
- AWS VPC creation (Amazon Web Services Virtual Private Cloud)
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