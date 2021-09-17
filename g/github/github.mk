# GitHub integration

.github-init:
	bash g/github/artifact-init
	@touch $@

$(BUILD)/artifact-timestamp:
	touch $@
	sleep 1

$(BUILD)/artifacts/done/artifact-init:
	bash g/github/artifact-init

$(BUILD)/artifacts/down/%: | $(BUILD)/artifacts/down/ $(BUILD)/artifacts/done/artifact-init
	bash g/github/dl-artifact $*
	mv $@.new/$* $@
	rm -rf $@.new
	ls -l $@

$(BUILD)/artifacts/extract/%: $(BUILD)/artifacts/down/% | $(BUILD)/artifacts/extract/
	tar -xf $<
	@touch $@

$(BUILD)/daily/extract/%: $(BUILD)/daily/down/% | $(BUILD)/daily/extract/
	tar --keep-newer-files -xf $<
	@touch $@

$(BUILD)/artifacts/up/pearl.macho: $(BUILD)/pearl.macho $(BUILD)/artifact-timestamp | $(BUILD)/artifacts/up/
	$(MKDIR) $(dir $@)
	$(CP) $< $@

$(BUILD)/daily/down/%: | $(BUILD)/daily/down/
	bash g/github/dl-daily $*

%{daily}: %
	for id in $$(curl -sSL "https://api.github.com/repos/$$GITHUB_REPOSITORY/releases/44921644/assets" | jq ".[] | if .name == \"$(notdir $*)\" then .id else 0 end"); do [ $$id != "0" ] && curl -sSL -XDELETE -H "Authorization: token $$GITHUB_TOKEN" "https://api.github.com/repos/$$GITHUB_REPOSITORY/releases/assets/$$id"; echo deleted; done
	curl -sSL -XDELETE -H "Authorization: token $$GITHUB_TOKEN" "https://api.github.com/repos/$$GITHUB_REPOSITORY/releases/44921644/assets?name=$(notdir $*)"; curl -sSL -XPOST -H "Authorization: token $$GITHUB_TOKEN" --header "Content-Type: application/octet-stream" "https://uploads.github.com/repos/$$GITHUB_REPOSITORY/releases/44921644/assets?name=$(notdir $*)" --upload-file $*; curl -sSL -XPATCH -H "Authorization: token $$GITHUB_TOKEN" --header "Content-Type: application/octet-stream" "https://uploads.github.com/repos/$$GITHUB_REPOSITORY/releases/44921644/assets?name=$(notdir $*)" --upload-file $*

$(BUILD)/artifacts{push}: .github-init
	(cd $(BUILD)/artifacts/up; for file in *; do name=$$(basename "$$file"); (cd $(PWD); bash g/github/ul-artifact "$$name" "$(BUILD)/artifacts/up/$$name") && rm -f "$(BUILD)/artifacts/up/$$name"; done)

$(BUILD)/%{artifact}: $(BUILD)/% .github-init
	$(MKDIR) $(BUILD)/artifacts/up
	$(CP) $< $(BUILD)/artifacts/up
	$(MAKE) $(BUILD)/artifacts{push}

$(BUILD)/%{release}: $(BUILD)/% .github-init
	$(MKDIR) $(BUILD)/release
	$(CP) $< $(BUILD)/release

$(BUILD)/github-releases{list}: .github-init | $(BUILD)/github-releases/
	curl -sSL https://api.github.com/repos/$$GITHUB_REPOSITORY/releases?per_page=100 | jq '.[] | [(.).tag_name,(.).id] | .[]' | while read tag; do read id; echo $$id > $(BUILD)/github-releases/$$tag; done
	curl -sSL https://api.github.com/repos/$$GITHUB_REPOSITORY/releases/tags/latest | jq '.[.tag_name,.id] | .[]' | while read tag; do read id; echo $$id > $(BUILD)/github-releases/$$tag; done
	ls -l $(BUILD)/github-releases/

%{upload-release}: .github-init | g/github/release/
	while ! test -e $(BUILD)/github-releases/'"'"$*"'"'; do sleep 10; $(MAKE) $(BUILD)/github-releases{list}; done
	for name in $$(cd $(BUILD)/release; ls *); do for id in $$(jq ".[] | if .name == \"$$name\" then .id else 0 end" < github/assets/$*.json); do [ $$id != "0" ] && curl -sSL -XDELETE -H "Authorization: token $$GITHUB_TOKEN" "https://api.github.com/repos/$$GITHUB_REPOSITORY/releases/assets/$$id"; echo; done; done
	(for name in $(BUILD)/release/*; do bname=$$(basename "$$name"); curl -sSL -XPOST -H "Authorization: token $$GITHUB_TOKEN" --header "Content-Type: application/octet-stream" "https://uploads.github.com/repos/$$GITHUB_REPOSITORY/releases/$$(cat $(BUILD)/github-releases/\"$*\")/assets?name=$$bname" --upload-file $$name; echo; done)

{release}: .github-init | github/ g/github/
	this_release_date="$$(date --iso)"; \
	node ./g/github/release.js $$this_release_date $$this_release_date > github/release.json; \
	curl -sSL -XPOST -H "Authorization: token $$GITHUB_TOKEN" "https://api.github.com/repos/$$GITHUB_REPOSITORY/releases" --data '@github/release.json'; \
	$(MAKE) $$this_release_date{upload-release}

%{checkout}:
	g/bin/locked --lockfile git.lock git submodule update --depth=1 --single-branch --init --recursive $*
