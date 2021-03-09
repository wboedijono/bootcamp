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

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the configuration and system files.
- 
- 

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

| Name     | Publicly Accessible | Allowed IP Addresses | Allowed Ports |
|----------|---------------------|----------------------|---------------|
| Jump Box | Yes (SSH)           | 120.154.110.138      | 22            |
| Web-1    | Yes (HTTP)          | 120.154.110.138      | 80            |
| Web-2    | Yes (HTTP)          | 120.154.110.138      | 80            |
| Web-3    | Yes (HTTP)          | 120.154.110.138      | 80            |
| Elk-1    | Yes (HTTP)          | 120.154.110.138      | 5601          |

### Elk Configuration
