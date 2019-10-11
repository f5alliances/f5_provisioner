# F5 PROVISIONER

## Overview
An automation sandbox as a service, deployed in AWS, which can be used with F5 best practice templates for major use-cases​.

## How to use?
 - [AWS Lab Provisioner](provisioner) - playbook that spins up instances on AWS for students to perform the exercises prov  ided above.

## So What?
 - Workbench information is stored in a local directory named after the workshop (e.g. TESTWORKSHOP/instructor_inventory) after the provisioner is run and is succesful. Example:
   ```
   [all:vars]
   ansible_port=22

   [student1]
   #Ansible control node
   student1-ansible ansible_host=34.219.251.xxx ansible_user=centos
   
   # BIG-IP
   
   student1-f5 ansible_host=52.39.228.xxx ansible_user=admin
   
   # Webserver
   student1-host1 ansible_host=52.43.153.xxx ansible_user=centos
   student1-host2 ansible_host=34.215.176.xxx ansible_user=centos
   ```
   
 - ssh to the ansible control node using studentx/ansible (x=studentID, example 1,2,3 etc.)

You can use it to:
- show case for real world customer automation scenarios​
- build public facing demos
- build new POC
- many more possibilities