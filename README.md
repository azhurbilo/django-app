[![Build Status](https://travis-ci.org/azhurbilo/django-app.svg?branch=master)](https://travis-ci.org/azhurbilo/django-app)

[![Galaxy](http://img.shields.io/badge/galaxy-zhurbilo.django--app-blue.svg?style=flat-square)](https://galaxy.ansible.com/list#/roles/2068)


django-app (Ansible role)
=========

Role was tested with Ansible version 1.8.2 and Ubuntu 14.04 LTS (Trusty Tahr) and 12.04 LTS

Ansible role to setup new django-project or deploy django project from git repo. There is a stack of tools using with django:

1. virtualenv - for isolating python environments
2. gunicorn - as python WSGI HTTP Server
3. supervisor - for managing the backend processes (start, stop and restart processes)
4. nginx - as reverse proxy server to gunicorn server
5. memcached - as in-memory key-value store 
6. logrotate - for managing logs: allows automatic rotation, compression, removal, and mailing of log files.

Each tool is allocated to separated file inside ./tasks/* directory, which contains all needed tasks for provisioning.


Requirements
------------

- [Ansible](http://docs.ansible.com/intro_installation.html)
- [Vagrant](http://www.vagrantup.com/downloads.html)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

Dependencies
------------

- [zhurbilo.base-ubuntu](https://galaxy.ansible.com/list#/roles/2046)

For installing this roles run:
    
    ansible-galaxy install -r ansible_requirements.txt --force
    
`ansible_requirements.txt` contains roles with its versions, which should be uploaded from ansible-galaxy (github).

Usage
------------
To set up you new application environment run:

    ./build.sh vagrant

If everything is Ok, you will see the output:

    Idempotence test after reboot: Success
    
    ==================
    SUCCESS
    ==================
      

Now your application is available on `http://192.168.33.3/`.
   
`build.sh` also run some additional time-consuming steps like:
  
* run the role/playbook again, checking to make sure it's idempotent (no changes).
* reboot virtual machine
* restart provisioning after machine reboot to make sure it's idempotent as well :smile:

Of course you can run ansible and vagrant commands separately, that is more flexible than run build.sh script.

    vagrant up
    ansible-playbook -i vagrant-inventory playbook.yml

Note: I don't use `vagrant ansible provisioner`, which do provisioning with one command `vagrant up`, but it complicates the usage of ansible.
In my opinion the provisiong way of you local virtual machine or EC2 Amazon instance should be the same.



Example Playbook
----------------

File `playbook.yml` contains an example of how to use this role

```yaml
- hosts: machine
  sudo: true
  vars:
    - django_app_git_url: 'git@github.com:azhurbilo/my-django-application.git'
    - django_application_name: 'project-name'
    - django_app_git_private_key: "{{ lookup('file', '~/.ssh/github') }}"
    - django_app_site_url: 'mysite.com'
  roles:
    - django-app
```

Vars list contains required parameters. Without these parameters provisioning will fail.
With lookup ansible module we can read contents from your local filesystem to get security data like private
ssh keys.


Role Variables
--------------

This role contains only "role defaults" variables, which are the most "defaulty" and lose in priority to everything.
So we can reset parameters in any way.

`django_app_git_url` argument affects on our provisioning.
If there is empty `` value, script execute `django-admin.py startproject` and init new git repo here.
If we set `django_app_git_url: git@github.com:<user>/<app>.git`, our application repo will be downloaded, all packages in
requirement.txt (pip) file will be installed and run some django commands like migrate or collectstatic.


License
-------

BSD

Author Information
------------------

Role was created by [Artem Zhurbila](http://www.linkedin.com/in/zhurbila)
