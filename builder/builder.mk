ifeq ($(BUILDER),)
$(PWD)/builder/packages/%{}:
	$(TIMESTAMP)

$(PWD)/builder/sysctl/%{}:
	$(TIMESTAMP)
else
$(PWD)/builder/packages/%{}: | $(PWD)/builder/packages/ $(PWD)/builder/update
	$(PWD)/g/bin/locked --lockfile $(PWD)/builder.lock sudo apt-get -y install $*
	$(TIMESTAMP)

$(PWD)/builder/update:
	$(PWD)/g/bin/locked --lockfile $(PWD)/builder.lock sudo apt-get -y update
	$(TIMESTAMP)

$(PWD)/builder/sysctl/overcommit_memory{}:
	echo 1 | sudo tee /proc/sys/vm/overcommit_memory
	$(TIMESTAMP)
endif

builder/packages/%{}: $(PWD)/builder/packages/%{}
	$(TIMESTAMP)

builder/sysctl/overcommit_memory{}: $(PWD)/builder/sysctl/overcommit_memory{}
