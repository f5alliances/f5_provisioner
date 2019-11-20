Tear down lab
=============

The teardown_lab.yml playbook deletes all the sandbox instances as well as local inventory files.

To destroy all the EC2 instances after training is complete:

Run the playbook with the same var files used to provision the infrastructure from the container

   .. code::
      docker run \
      -e AWS_ACCESS_KEY_ID=ABCDEFGHIJKLMNOP \
      -e AWS_SECRET_ACCESS_KEY=ABCDEFGHIJKLMNOP/ABCDEFGHIJKLMNOP \
      -v $(pwd)/../provisioner:/ansible/playbooks \
      f5_sandbox_provisioner teardown_lab.yml -e @f5_vars.yml
