Build environment
=================

One Time Setup
--------------

**Install docker**

Using your local machine or a dedicated host, install [Docker](https://docs.docker.com/install/).
Elsewhere in these instructions we will refer to the machine with the docker installation as **docker_host**.

**Clone the Repo**

Clone the workshop repository on the **docker_host**.

.. code::

   git clone https://github.com/f5alliances/f5_provisioner.git

**Build the container**

The `docker build<https://docs.docker.com/engine/reference/commandline/build/>`_ command builds an image from a **Dockerfile**.
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

.. note::

   Remember to tear down the lab when not is use
 
   .. code::

      docker run \
      -e AWS_ACCESS_KEY_ID=ABCDEFGHIJKLMNOP \
      -e AWS_SECRET_ACCESS_KEY=ABCDEFGHIJKLMNOP/ABCDEFGHIJKLMNOP \
      -v $(pwd)/../provisioner:/ansible/playbooks \
       f5_sandbox_provisioner teardown_lab.yml -e @f5_vars.yml
