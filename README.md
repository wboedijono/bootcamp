## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![](https://github.com/wboedijono/bootcamp/blob/master/Diagrams/HW13-NetworkDiagram.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook file may be used to install only certain pieces of it, such as Filebeat.

#### Playbook 1: pentest.yml
```
---
- name: Config Web VM with Docker
  hosts: webservers
  become: true
  tasks:
    - name: docker.io
      apt:
        force_apt_get: yes
        update_cache: yes
        name: docker.io
        state: present

    - name: Install pip3
      apt:
        name: python3-pip
        state: present

    - name: install Docker python module
      pip:
        name: docker
        state: present

    - name: download and launch a docker web container
      docker_container:
        name: dvwa
        image: cyberxsecurity/dvwa
        state: started
        restart_policy: always
        published_ports: 80:80

    - name: Enable docker service
      systemd:
        name: docker
        enabled: yes
```
 
       
#### Playbook 2: install-elk.yml
```
---
- name: Configure Elk VM with Docker
  hosts: elk
  remote_user: BOSSRED1
  become: true
  tasks:
    # Use apt module
    - name: Install docker.io
      apt:
        update_cache: yes
        force_apt_get: yes
        name: docker.io
        state: present

      # Use apt module
    - name: Install python3-pip
      apt:
        force_apt_get: yes
        name: python3-pip
        state: present

      # Use pip module (It will default to pip3)
    - name: Install Docker module
      pip:
        name: docker
        state: present

      # Use command module
    - name: Increase virtual memory
      command: sysctl -w vm.max_map_count=262144

      # Use sysctl module
    - name: Use more memory
      sysctl:
        name: vm.max_map_count
        value: 262144
        state: present
        reload: yes

      # Use docker_container module
    - name: download and launch a docker elk container
      docker_container:
        name: elk
        image: sebp/elk:761
        state: started
        restart_policy: always
        # Please list the ports that ELK runs on
        published_ports:
          -  5601:5601
          -  9200:9200
          -  5044:5044

      # Use systemd module
    - name: Enable service docker on boot
      systemd:
        name: docker
        enabled: yes
```

#### Playbook 3: filebeat-playbook.yml
```
---
- name: installing and launching filebeat
  hosts: webservers
  become: yes
  tasks:

  - name: download filebeat deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb

  - name: install filebeat deb
    command: dpkg -i filebeat-7.4.0-amd64.deb

  - name: drop in filebeat.yml
    copy:
      src: /etc/ansible/files/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml

  - name: enable and configure system module
    command: filebeat modules enable system

  - name: setup filebeat
    command: filebeat setup

  - name: start filebeat service
    command: service filebeat start

  - name: enable service filebeat on boot
    systemd:
      name: filebeat
      enabled: yes
```
    

### This document contains the following details:

* Description of the Topology
* Access Policies
* ELK Configuration
* Beats in Use
* Machines Being Monitored
* How to Use the Ansible Build


### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network.
- It increases availability of applications and websites for users by distributing network traffic across multiple servers.
- With Jumpbox, it improves the security, by eliminating a direct admin access to the Servers or Network.
  It's because any threats may hide undetectable inside the admins PC.  

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the specific data and system files.
- Filebeat monitors the log files or locations that you specify, collects log events, and forwards them either to Elasticsearch or Logstash for indexing.
- Metricbeat periodically collect metrics and statistics from the operating system and from services running on the server.  Then, it ships them to the specified output, such as Elasticsearch or Logstash.

The configuration details of each machine may be found below.

| Name                | Function | IP Address | Operating System |
|---------------------|----------|------------|------------------|
| JumpBox Provisioner | Gateway  | 10.0.0.4   | Linux            |
| Web1                | DVWA     | 10.0.0.9   | Linux            |
| Web2                | DVWA     | 10.0.0.12  | Linux            |
| Web3                | DVWA     | 10.0.0.13  | Linux            |
| VMELKLAB-1          | ELK      | 10.1.0.4   | Linux            |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the JumpBox Provisioner machine can accept SSH connections from the Internet. Access to this machine is only allowed from the following IP addresses:
- 121.219.101.88

Machines within the network can only be accessed by the JumpBox Provisioner.
- Only JumpBox Provisioner that allow to access VMELKLAB-1 using SSH. 10.0.0.4 is the JumpBox Provisioner.

A summary of the access policies in place can be found in the table below.

| Name                | Publicly Accessible | Allowed IP Addresses | Allowed Ports |
|---------------------|---------------------|----------------------|---------------|
| JumpBox Provisioner | Yes (SSH)           | 121.219.101.88       | 22            |
| Web1                | Yes (HTTP)          | 121.219.101.88       | 80            |
| Web2                | Yes (HTTP)          | 121.219.101.88       | 80            |
| Web3                | Yes (HTTP)          | 121.219.101.88       | 80            |
| VMELKLAB-1          | Yes (HTTP)          | 121.219.101.88       | 5601          |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because:

- Very simple to setuup and user: No special coding skills are necessary to use.
- Difficult manual tasks become repeatable and less vulnerable to error.
- It streamlines and simplifies cloud provisioning, configuration management, application deployment, intra-service orchestrations, processes and infrastructure.

### Playbooks

The three playbooks above implement the following tasks:

#### Playbook 1: pentest.yml
pentest.yml is an Ansible playbook file to install Docker and configure a VM with the DWA web app. It runs the following tasks:

- Installs Docker
- Installs Python
- Installs Docker's Python Module
- Downloads the DVWA Docker container with image name cyberxsecurity/dvwa
- Launches the DVWA Docker container with Web port 80 and with restart_policy=always
- Enables the Docker as a service

#### Playbook 2: install-elk.yml
install-elk.yml is a playbook file to install Docker and configure a VM with  the ELK repository app.  It runs the following tasks:

- Installs Docker
- Installs Python
- Installs Docker's Python Module
- Increases virtual memory
- Instructs to use the increased memory
- Downloads the Docker ELK container with image name sebp/elk
- Launches the Docker ELK container with ports: 5601, 9200, 5044
- Enables the Docker as a service

#### Playbook 3: filebeat-playbook.yml
filebeat-playbook.yml is a playbook file to install Filebeat agent on each of the DVWA web servers for fetching the specified data for ELK monitoring purpose.  It runs the following tasks:

- Downloads Filebeat Debian package by using curl command
- Installs Filebeat Debian package
- Drops in a playbook file name filebeat.yml by copying from filebeat-config.yml
- Enables and configures the Filebeat module
- Setup Filebeat
- Launches Filebeat
- Enable the Filebeat as a service


The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![](https://github.com/wboedijono/bootcamp/tree/master/Diagrams/dockerps.jpg)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web1: 10.0.0.9
- Web2: 10.0.0.12
- Web3: 10.0.0.13

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:

- Most common that Filebeat collects from VMs running the Filebeat agent are the system logs. One of examples is the system tick value from Syslog .
- Metricbeat collects metrics from the operating system and services of VMs. For an example: system.process.cpu.total counter.


### Using the Playbooks
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the /etc/ansible/install-elk.yml file to Ansible Docker Container.
- Update the Ansible hosts file `/etc/ansible/hosts` to include the following: 

```
[webservers]
10.0.0.9 ansible_python_interpreter=/usr/bin/python3
10.0.0.12 ansible_python_interpreter=/usr/bin/python3
10.0.0.13 ansible_python_interpreter=/usr/bin/python3

[elk]
10.1.0.4 ansible_python_interpreter=/usr/bin/python3
```
- Update the remote_user value to the defined Azure VM's administrator username in /etc/ansible/ansible.cfg

- Run the playbook, and navigate to the status of Play Recap, navigate to ELK machine(via SSH) and run "sudo docker ps", and navigate to http://52.231.202.32:5601 to check that the installation worked as expected.
- To run playbook for filebeat and metricbeat, the above steps have fullfilled a few part of basic requirements. For examples, the ansible.cfg and hosts. The Filebeat-config.yml and metricbeat-config.yml need to be adjusted (as shown below) then copy them into /etc/ansible/files, so then they will be copied by the playbook into the VM which need the agent. 
  ```
  output.elasticsearch:
  hosts: ["10.1.0.4:9200"]
  username: "elastic"
  password: "changeme"

  ...

  setup.kibana:
  host: "10.1.0.4:5601"
  ```


