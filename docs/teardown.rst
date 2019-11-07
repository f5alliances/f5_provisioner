TEAR DOWN LAB
=============

The teardown_lab.yml playbook deletes all the sandbox instances as well as local inventory files.

To destroy all the EC2 instances after training is complete:

1. Run the playbook:

   .. code:: 

      ansible-playbook teardown_lab.yml -e @f5_vars.yml
