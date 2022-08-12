$(BUILD)/artifact-timestamp:
	touch $@
	sleep 1

$(BUILD)/artifacts/down/%: | $(BUILD)/artifacts/down/
	$(CP) $(FACTION)/artifacts/$* $@
	ls -l $@

$(BUILD)/artifacts/down/%{}: | $(BUILD)/artifacts/down/
	$(CP) $(FACTION)/artifacts/$* $@
	ls -l $@

$(BUILD)/artifacts/extract/%: $(BUILD)/artifacts/down/% | $(BUILD)/artifacts/extract/
	tar -xf $<
	@touch $(patsubst %{},%,$@)

$(BUILD)/artifacts{push}:
	$(MKDIR) $(FACTION)/artifacts
	(cd $(BUILD)/artifacts/up; for file in *; do name=$$(basename "$$file"); $(CP) $$file $(FACTION)/artifacts/$$name; done)

$(BUILD)/%{artifact}: $(BUILD)/%
	$(MKDIR) $(BUILD)/artifacts/up
	$(CP) $< $(BUILD)/artifacts/up
	$(MAKE) $(BUILD)/artifacts{push}

%{checkout}:
	(cd $*; $(PWD)/g/bin/locked --lockfile $(PWD)/git.lock git submodule update --depth=1 --single-branch --init --recursive .)

$(BUILD)/released/%:
	$(MKDIR) $(dir $(BUILD)/released/$*)
	wget -O $@ https://github.com/$(word 1,$(subst /, ,$*))/$(word 2,$(subst /, ,$*))/releases/latest/download/$(word 3,$(subst /, ,$*))

$(BUILD)/released/%{}:
	$(MKDIR) $(dir $(BUILD)/released/$*)
	wget -O $(patsubst %{},%,$@) https://github.com/$(word 1,$(subst /, ,$*))/$(word 2,$(subst /, ,$*))/releases/latest/download/$(word 3,$(subst /, ,$*))
