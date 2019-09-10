# F5 Sandbox

## LAB PROVISIONER
 - [AWS Lab Provisioner](provisioner) - playbook that spins up instances on AWS for students to perform the exercises provided above.

## SELF-PACED EXERCISES
 - cd networking-workshop
 - To execute the playbooks run commands
   - ansible-playbook 1.1-get-facts/bigip-facts.yml
     - Display system level facts about the BIG-IP
   - ansible-playbook 1.2-add-node/bigip-node.yml
     - Add nodes to the BIG-IP
   - ansible-playbook 1.3-add-pool/bigip-pool.yml
     - Add pools to the BIG-IP (using a variable file)
   - ansible-playbook 1.4-add-pool-members/bigip-pool-members.yml
     - Add nodes in step2 to pools (pool members)
   - ansible-playbook 1.5-add-virtual-server/bigip-virtual-server.yml
     - Add virtual servers (using a variable file)
   - ansible-playbook 1.6-add-irules/bigip-irule.yml
     - Add irules to one virtual server
   - ansible-playbook 1.7-save-running-config/bigip-config.yml
     - Save the running configuration on the BIG-IP
   - ansible-playbook 1.8-virtual-server-facts/bigip-virtual-server-facts.yml
     - Display and parse virtual server facts from the BIG-IP
   - ansible-playbook 2.0-disable-pool-member/disable-pool-member.yml
     - Disable 'All' or a particular pool member
   - ansible-playbook 2.1-delete-configuration/bigip-delete-configuration.yml
     - Delete all the BIG-IP configuration
   - ansible-playbook 2.2-error-handling/bigip-error-handling.yml
     - Manage error handling using block, rescue, always in ansible
   - ansible-playbook 3.0-as3-intro/as3.yml
     - Deploy an HTTP application using AS3
   -  ansible-playbook 3.1-as3-change/as3.yml
      - Modify an AS3 declaration and push to the BIG-IP
   - ansible-playbook 3.2-as3-delete/delete.yml
     - Delete AS3 declaration
   - ansible-playbook 3.3-a3-asm/asm_as3.yml
     - Deploy an HTTP application with a WAF policy
