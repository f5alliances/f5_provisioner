Build environment
=================

One Time Setup
--------------

**Install docker**

Using your local machine or a dedicated host, install `Docker <https://docs.docker.com/install/>`_.
Elsewhere in these instructions we will refer to the machine with the docker installation as **docker_host**.

**Clone the Repo**

Clone the workshop repository on the **docker_host**.

.. code::

   git clone https://github.com/f5alliances/f5_provisioner.git

**Build the container**

The `docker build <https://docs.docker.com/engine/reference/commandline/build/>`_ command builds an image from a **Dockerfile**.
This image will be used to run the Ansible playbooks for the provisioner.
From the directory containing the **Dockerfile**, run the build command.
This command will take a few minutes to complete.

.. code::

   cd f5_provisioner/docker
   docker build --no-cache -t f5_sandbox_provisioner .
   
**AWS Setup**

- Create an Amazon AWS account
- Create an Access Key ID and Secret Access Key. Save the ID and key for later.
- New to AWS and not sure what this step means? `Click here <https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/>`__
- Make sure you have subscribed to the right marketplace AMI (Amazon Machine Image).
  - F5 BIG-IP `Click here to subscribe <https://aws.amazon.com/marketplace/pp/B079C44MFH/>`__

Run provisioner
---------------

Now you can start to provision the environment in AWS.

**Make sure you move to the correct directory after the git clone and building the container above**

.. code::
   
   cd f5_provisioner/provisioner

1. Configure f5_vars.yml to reflect your environment under provisioning.

   - Modify the AWS region on which the infrastructure will spin up
   - Modify the ec2_name_prefix to represent a workshop unique to your environment
   - Modify the number of students for which the environment needs to be spun up
   - There is a dependancy on your personal AWS environment resources available if you have a large number of students
     - Modify the password, this password will be used to login to all machines including BIG-IP	  

   .. code:: yaml

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

2. Run the playbook:

   Use the AWS ID and KEY saved earlier

   .. code:: 

      docker run \
      -e AWS_ACCESS_KEY_ID=ABCDEFGHIJKLMNOP \
      -e AWS_SECRET_ACCESS_KEY=ABCDEFGHIJKLMNOP/ABCDEFGHIJKLMNOP \
      -v $(pwd)/../provisioner:/ansible/playbooks \
      f5_sandbox_provisioner provision_lab.yml -e @f5_vars.yml

   This command will take several minutes to complete.

   - The command mounts the repository's ``provisioner`` directory inside the container (``-v``) and passes AWS credentials as environment    variables (``-e``) to the container (the ``-e`` on the last line passes env variables to **ansible itself** and is not part of the      docker command). 
   - Docker supports multiple methods to `pass environment variables to a container <https://docs.docker.com/engine/reference/commandline/run/#set-environment-variables--e---env---env-file>`_
   - If the environment variable already exists, the ``-e VARIABLE`` construction prevents sensitive information from appearing in bash history or the running proc.
   - Alternatively, If using an `AWS CLI credential file <https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html>`_ a mapped volume could be used. For example:

   .. code::
      
      docker run \
      -v ~/.aws/credentials:/root/.aws/credentials \
      -v $(pwd)/../provisioner:/ansible/playbooks \
      f5_sandbox_provisioner provision_lab.yml -e @f5_vars.yml

   .. note::

      **If the provisioning is not successful**, please teardown the lab by running the teardown playbook.

   .. code::

      docker run \
      -e AWS_ACCESS_KEY_ID=ABCDEFGHIJKLMNOP \
      -e AWS_SECRET_ACCESS_KEY=ABCDEFGHIJKLMNOP/ABCDEFGHIJKLMNOP \
      -v $(pwd)/../provisioner:/ansible/playbooks \
       f5_sandbox_provisioner teardown_lab.yml -e @f5_vars.yml

   .. note::

     Correct the issue and run the provision playbook again (Step 2).

3. Login to the AWS EC2 console and you should see instances being created like:

   .. code ::

      TESTWORKSHOP1-studentX-ansible

Access the Lab
--------------

Once the provisioner has run successfully and infrastructure has been spun up.

All the workbench information is stored in a local directory named after the workshop (e.g. TESTWORKSHOP1/instructor_inventory.txt) after the provisioner is run and is succesful. 

Example: Make sure to go to the provisioner directoy

.. code::

   cd f5_provisioner/provisioner
   cat TESTWORKSHOP1/instructor_inventory.txt
   
   [all:vars]
   ansible_port=22

   [student1]
   student1-ansible ansible_host=34.219.251.xxx ansible_user=centos #Ansible host/control node
   student1-f5 ansible_host=52.39.228.xxx ansible_user=admin        #BIG-IP
   student1-host1 ansible_host=52.43.153.xxx ansible_user=centos    #Backend application server1
   student1-host2 ansible_host=34.215.176.xxx ansible_user=centos   #Backend application server2

.. note::

   If there are more students configured there will be more entries to represent each student
   
1. Login to Ansible control node (IP from inventory file above) using the studentID and the password
   mentioned in the f5_vars.yml earlier

.. code::

   ssh student1@34.219.251.xxx
   student1@34.219.251.xxx's password:
   
2. Run the ansible command with the --version command. The latest version of ansible will be installed

   .. code::

      [student1@ansible networking-workshop]$ ansible --version
       ansible 2.8.5
         config file = /home/student1/.ansible.cfg
         configured module search path = [u'/home/student1/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
         ansible python module location = /usr/lib/python2.7/site-packages/ansible
         executable location = /usr/bin/ansible
         python version = 2.7.5 (default, Oct 30 2018, 23:45:53) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]

   .. note::
    
      The version of ansible you have might differ from above (the latest ansible version gets installed)
	
3. Use the commands below to view the contents of your inventory

   .. code::

      [student1@ansible ~]$ cd networking-workshop/
      [student1@ansible networking-workshop]$ cat lab_inventory/hosts

   The output will look as follows with student1 being the respective student workbench:

   .. code::

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
	  
   .. note::
    
      The IP's in your environment will defer.
	  
      The values from the inventory file will be used in subsequent playbooks
	
4. Using your text editor of choice create a new file called bigip-facts.yml in the home directory ~/

   The BIG-IP input values are taken from the inventory file mentioned earlier

   .. code:: yaml

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

5. Run the playbook - exit back into the command line of the control host and execute the following:

  .. code:: bash

     cd ~/
     [student1@ansible ~]$ ansible-playbook bigip-facts.yml

6. The output will look as follows. This playbook is grabbing information from the BIG-IP and displaying the relevant information.

.. code::

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
   
You have been successful in logging into the BIG-IP and grabbing/displaying facts. 
Your access to the BIG-IP is verified.

**Congratulations, your lab is up and running!**

