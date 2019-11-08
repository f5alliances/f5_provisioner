Tear down lab
=============

The teardown_lab.yml playbook deletes all the sandbox instances as well as local inventory files.

To destroy all the EC2 instances after training is complete:

1. Login to the Ansible host **ansible_server_provioner**

2. Run the playbook with the same var files used to provision the infrastructure

   .. code:: 

      cd f5_provisioner/provisioner
      ansible-playbook teardown_lab.yml -e @f5_vars.yml
