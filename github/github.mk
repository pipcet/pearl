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
{release}:
	this_release_date="$$(date --iso)"; \
	node ./github/release.js $$this_release_date $$this_release_date > github/release.json; \
	curl -sSL -XPOST -H "Authorization: token $$GITHUB_TOKEN" "https://api.github.com/repos/$$GITHUB_REPOSITORY/releases" --data '@github/release.json'; \
	$(MAKE) ship/$$this_release_date!
