# Ansible

Ansible is a tool used to automate the configuration of remote nodes. Its main feature is the absence of an agent-server structure. Ansible can be installed on one machine, which does not have to be a manager or a major node in the network topology; the only requirement is the ability to establish a connection. Ansible connects via **SSH** and executes standard bash commands. Additionally, Ansible collects information or *facts* about remote machines, allowing it not only to change the configuration state of a node but also to store information about changes to that state and ensure that the state remains unchanged by the configurator. Since the node itself is naturally "unprotected" for manual configuration, Ansible ensures that the state remains unchanged.

To get started with Ansible, create an inventory file containing the addresses or domain names of all remote hosts requiring configuration. For Vagrant virtual machines, these are the IP addresses on the internal Vagrant network.

To run an action or module on all connected machines using Ansible, execute the following command: `ansible all --key-file <path to ssh key> -i <path to inventory file> -m <model name>`.

The official documentation contains information about all available modules. Use the command `man ansible` to familiarize yourself with the other keys, some of which you may need to run commands with root privileges, for example.

Many Ansible commands can be combined into a single YML-file — a playbook. The simplest playbook has the following structure:


```yml
- hosts: <group>               # By default — all
 <key №1>: <value №1>      # Additional keys and arguments similar to ansible
 <key №2>: <value №2>
 <key №2>: <value №3>
 tasks:                        # Task list
   - name: <task name №1>     # Task name
     <module name>:             # Module and its parameters
       <parameter №1>: <value №1>
       <parameter №2>: <value №2>
       <parameter №3>: <value №3>
   - name: <task name №2>     # Task name
     <module name>:             # Module and its parameters
       <parameter №1>: <value №1>
       <parameter №2>: <value №2>
       <parameter №3>: <value №3>
   <...>
```

To run the playbook, enter the command: `ansible-playbook <playbook name>`.

Playbooks Ansible support the creation of roles. Roles allow you to logically allocate commands to individual files located in a specific directory tree structure:

```
./roles/
----role1/
--------tasks/
------------main.yml            //tasks of the first role
----role2/
--------tasks/
------------main.yml            //tasks of the second role
----role3/
--------tasks/
------------main.yml            //tasks of the third role
```

In addition to tasks, you can set your templates, variables (vars), and other useful things in the roles.
