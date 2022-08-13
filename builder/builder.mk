ifeq ($(BUILDER),)
$(PWD)/builder/packages/%{}:
	$(TIMESTAMP)
else
$(PWD)/builder/packages/%{}: $(PWD)/builder/packages/
	$(PWD)/g/bin/locked --lockfile $(PWD)/builder.lock sudo apt-get -y install $*
	$(TIMESTAMP)
endif
