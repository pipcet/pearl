ifeq ($(BUILDER),)
$(PWD)/builder/packages/%{}:
	$(TIMESTAMP)
else
$(PWD)/builder/packages/%{}: | $(PWD)/builder/packages/ $(PWD)/builder/update
	$(PWD)/g/bin/locked --lockfile $(PWD)/builder.lock sudo apt-get -y install $*
	$(TIMESTAMP)

$(PWD)/builder/update:
	$(PWD)/g/bin/locked --lockfile $(PWD)/builder.lock sudo apt-get -y update
	$(TIMESTAMP)
endif

builder/packages/%{}: $(PWD)/builder/packages/%{}
	$(TIMESTAMP)
