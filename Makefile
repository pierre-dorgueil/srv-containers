all:
	@echo "srv-containers - tested on RHEL8.1, CentOS8.x, fedora 32-33 hosts"
	@echo "make archive : create archive from system binaries"
	@echo "make install : extract archive to system binaries"
	@echo "make push    : submit changes to github"
	@echo "make pull    : reinstall from github"

arch = srv.txz
base = var/lib/srv-containers
exe  = bin/srv
serv = usr/lib/systemd/system/srv.service
read = /$(base)/README

excl = --exclude $(base)/build/'*-*' \
       --exclude $(base)/srv-containers.conf \
       --exclude $(base)/srv-containers.conf.bak \
       --exclude $(base)/COPYING

archive:
	(cd /; sudo tar cJf - $(excl) $(exe) $(base) $(serv)) > $(arch)

install:
	(cd /; sudo tar xJvf -) < $(arch)
	@[ -x /sbin/restorecon ] && sudo /sbin/restorecon -v /bin/srv /$(serv) || :

readme:
	@{ printf '==============\nsrv-containers\n==============\n\n::\n\n'; \
           cat $(read) | \
           sed "s~^Usage.*~$$(srv|tr '\n' %)~" | \
           sed "s/examples/examples ($$(cd /$(base)/build;ls *.tmpl|tr -d '\n'|sed 's/\.tmpl/,/g;s/end,//'))/" | \
           sed 's/[^m]*m//g;s/,)/)/;s/%/\n/g;s/^/ /'; } > README.rst

push: readme
	@make archive && git add .; v=$$(egrep '^ +- +v' $(read)|tail -1|sed 's/ \+- \+//'); git commit -m "$$v"; git push origin main

pull:
	@git pull origin main && make install
