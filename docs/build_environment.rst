Build environment
=================

One Time Setup
--------------

Following needs to be installed on the **ansible_server_provioner**

1. Install Python - latest version of Python (2.7 minimum) if you do not
   already have it.

   -  http://www.python.org/

2. Install Ansible version 2.8.0 minimum:

   -  http://docs.ansible.com/ansible/latest/intro_installation.html

   If you run Ansible by using virtualenv/pip, please refer to `Install snsible by using
   virtualenv <https://clouddocs.f5.com/products/orchestration/ansible/devel/usage/virtualenv.html>`__.

   After installation run the following command to verify ansible installation

   .. code:: shell

      # ansible --version
      ansible 2.8.5
       config file = None
       configured module search path = ['/Users/test/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
       ansible python module location = /Users/test/myansible/lib/python3.7/site-packages/ansible
       executable location = /Users/test/myansible/bin/ansible
       python version = 3.7.3 (default, Jun 19 2019, 07:40:11) [Clang 9.0.0 (clang-900.0.39.2)]

3. AWS Setup

   A. Create an Amazon AWS account

   B. Create an Access Key ID and Secret Access Key. Save the ID and key for later.

     - New to AWS and not sure what this step means? `Click here <https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/>`__

   C. Install boto, boto3 , netaddr and passlib on the **ansible_server_provisioner**

      .. code::

         pip install boto boto3 netaddr passlib

   D. Set your Access Key ID and Secret Access Key from Step B under ~/.aws/credentials in the **ansible_server_provisioner**

      .. code::

         [root@centos ~]# cat ~/.aws/credentials
         [default]
         aws_access_key_id = ABCDEFGHIJKLMNOP
         aws_secret_access_key = ABCDEFGHIJKLMNOP/ABCDEFGHIJKLMNOP

4. Clone the workshop repo on the **ansible_server_provisioner**

   .. code::

      git clone https://github.com/f5alliances/f5_provisioner.git
      cd f5_provisioner/provisioner

5. Make sure you have subscribed to the right marketplace AMI (Amazon Machine Image).

   -  F5 BIG-IP `Click here to subscribe.<https://aws.amazon.com/marketplace/pp/B079C44MFH/>`__
