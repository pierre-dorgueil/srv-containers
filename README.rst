==============
srv-containers
==============

::

 Description : test linux operating system distributions as containers
 Copyright :   2020 Pierre Dorgueil (pierre.dorgueil@gmail.com)
 License :     https://www.gnu.org/licenses/gpl-3.0.txt
 
 History :
  - v0.1  20201026 early version	            pierre.dorgueil@gmail.com
 
 
 Usage : /usr/bin/srv command target
  commands :
     list      : show active servers
     listall   : show all servers
     ssh       : ssh connect a running server
     start     : start a server
     stop      : cleanly stops a running server
     poweroff  : immediately stops a server
     restart   : restart a running server
     reset     : restart a server from image !!! all changes are lost
     fullreset : rebuild a server image from scratch, then 'reset'

     check     : check for a basic commands set on started servers

  targets :
     all (or no target) to address all defined servers
     a space separated list of servers names or numbers, between 1 and 12

 
 
 Contents :
    /bin/srv : main binary. type srv without args for a short help
    /var/lib/srv-containers/README : this file
    /var/lib/srv-containers/COPYING : license copy
    /var/lib/srv-containers/srv-containers.conf : main configuration file
      - servers declarations
      - exe files/commands to check for presence
    /var/lib/srv-containers/build/ : containers building files
      - templates for each os (*.tmpl)
      - buildfiles for each server (don't edit them, only templates)
      - makebuildfiles : update buildfiles from templates
      - dot-ssh : authorized_keys file to inject into containers for passwordless access
 
 
 Startup instructions :
   # cd /var/lib/srv-containers
   # cp srv-containers.conf.sample srv-containers.conf
   # vi srv-containers.conf
       declare the servers to run
         1st column is the container dns name
           container name is srv#, first declared is 1
         2nd column is the name of the dockerfile. must match one file in ./build
         3rd column contains a * if the container must start with the host machine
           this field is rewritten by srv.service when host stops, to save the state
 	  when srv.service starts, all * containers are started
         remaining of the line may contain comments
       declare the commands to validate on each container (srv check)
 
   # su - tux     (the user which will manage containers must be sudoer without password)
   $ srv start    (build and start all declared containers - may take time)
 
     app-adm and root password are both first part of build file name
       ex : suse-leap -> password is suse
 
 
 Build templates :
 
   use provided templates as examples (alpine,centos,debian,fedora,kali,suse,ubuntu)
 
   to find which remote package contains a needed file, from within the running container,
     fedora/centos : yum provides '*/file'
     suse :          zypper se --provides '*/file'
     debian/ubuntu : apt-file update; apt-file search '*/file'
     alpine :        apk-file update; apk-file search '*/file'
 
