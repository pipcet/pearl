# GitHub integration

.github-init:
	bash github/artifact-init
	touch $@

build/artifact-timestamp:
	touch $@
	sleep 1

build/artifacts/up/pearl.macho: build/pearl.macho build/artifact-timestamp | build/artifacts/up/
	$(MKDIR) $(dir $@)
	$(CP) $< $@

build/artifacts{push}:
	(cd build/artifacts/up; for file in *; do if [ "$$file" -nt ../../artifact-timestamp ]; then name=$$(basename "$$file"); (cd $(PWD); bash github/ul-artifact "$$name" "build/artifacts/up/$$name"); fi; done)

build/%{artifact}: build/%
	$(MKDIR) build/artifacts/up
	$(CP) $< build/artifacts/up
	$(MAKE) build/artifacts{push}

build/%{release}: build/%
	$(MKDIR) build/release
	$(CP) $< build/release

%{release}: | github/release/
	$(MAKE) github/release/list!
	for name in $$(cd build/release; ls *); do for id in $$(jq ".[] | if .name == \"$$name\" then .id else 0 end" < github/assets/$*.json); do [ $$id != "0" ] && curl -sSL -XDELETE -H "Authorization: token $$GITHUB_TOKEN" "https://api.github.com/repos/$$GITHUB_REPOSITORY/releases/assets/$$id"; echo; done; done
	(for name in build/release/*; do bname=$$(basename "$$name"); curl -sSL -XPOST -H "Authorization: token $$GITHUB_TOKEN" --header "Content-Type: application/octet-stream" "https://uploads.github.com/repos/$$GITHUB_REPOSITORY/releases/$$(cat github/release/\"$*\")/assets?name=$$bname" --upload-file $$name; echo; done)

{release}:
	this_release_date="$$(date --iso)"; \
	node ./github/release.js $$this_release_date $$this_release_date > github/release.json; \
	curl -sSL -XPOST -H "Authorization: token $$GITHUB_TOKEN" "https://api.github.com/repos/$$GITHUB_REPOSITORY/releases" --data '@github/release.json'; \
	$(MAKE) $$this_release_date{release}
