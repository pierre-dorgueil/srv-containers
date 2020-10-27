all:
	@echo "make archive : create archive from system binaries"
	@echo "make install : install archive to system binaries"
	@echo "make install_to_local : install archive to local copy (./root)"
	@echo "make install_from_local : install local copy to system binaries"

vers = 0.1

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

install_from_local:
	(cd root; tar cJf - $(excl) $(exe) $(base) $(serv)) > $(arch)
	make install

install_to_local:
	(cd root; rm -rf *; tar xJvf -) < $(arch)

readme:
	@{ printf '==============\nsrv-containers\n==============\n\n::\n\n'; \
           cat /$(base)/README | \
           sed "s~^Usage.*~$$(srv|tr '\n' %)~" | \
           sed "s/examples/examples ($$(cd /$(base)/build;ls *.tmpl|tr -d '\n'|sed 's/\.tmpl/,/g;s/end,//'))/" | \
           sed 's/[^m]*m//g;s/,)/)/;s/%/\n/g;s/^/ /'; } > README.rst

push: readme
	@git add .; git commit -m v$(vers); git push origin main
