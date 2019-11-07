Run provisioner
===============

Now you can start to provision the environment in AWS.

Make sure you are in the correct directory after the git clone

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

   .. code::

      ansible-playbook provision_lab.yml -e @f5_vars.yml

.. note::

   **If the provisioning is not successful**, please teardownthe lab using command
   ``ansible-playbook teardown_lab.yml -e @f5_vars.yml`` and then run the provision playbook again (Step 2)

3. Login to the AWS EC2 console and you should see instances being created like:

   .. code ::

      TESTWORKSHOP1-studentX-ansible
|

.. image:: images/provisioner.gif

|
   
.. note::

   Remember to tear down the lab when not is use by following
   `ansible-playbook teardown_lab.yml -e @f5_vars.yml`, to avoid unexpected AWS charges!