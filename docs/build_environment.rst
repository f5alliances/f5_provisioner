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
