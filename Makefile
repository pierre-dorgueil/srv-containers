all:
	@echo "make archive : create archive from system binaries"
	@echo "make install_to_local : install archive to local copy (./root)"
	@echo "make install : install archive to system binaries"

vers = 0.1.2
chgs = check podman version, tests on RHEL8.1, CentOS8, fedora 32 hosts

arch = srv.txz
base = var/lib/srv-containers
exe  = bin/srv
serv = usr/lib/systemd/system/srv.service
incl = bin/srv \
       $(base) \
       $(serv) \

excl = --exclude $(base)/build/dot-ssh/* \
       --exclude $(base)/srv-containers.conf \
       --exclude $(base)/COPYING

archive:
	(cd /; sudo tar cJf - $(excl) $(exe) $(base) $(serv)) > $(arch)

install:
	(cd /; sudo tar xJf -) < $(arch)
	sudo /sbin/restorecon -v /bin/srv /$(serv)

install_to_local:
	(cd root; rm -rf *; tar xJvf -) < $(arch)

readme:
	@{ printf '==============\nsrv-containers\n==============\n\n::\n\n'; \
           cat /$(base)/README | \
           sed "s~^Usage.*~$$(srv|tr '\n' %)~" | \
           sed "s/examples/examples ($$(cd /$(base)/build;ls *.tmpl|tr -d '\n'|sed 's/\.tmpl/,/g;s/end,//'))/" | \
           sed 's/[^m]*m//g;s/,)/)/;s/%/\n/g;s/^/ /'; } > README.rst

push: readme
	@git add . && git commit -m "v$(vers)i : $(chgs)" && git push origin main
