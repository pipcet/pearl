# This is in the g/ subdir of the m1 repository, but it's meant to be
# run in the repository itself, as make -f g/Makefile daily!

all!: daily!

daily!: fetch-canon! fetch-all! fetch-canon!

fetch-canon!:
	g/bin/fetch-canon

fetch-upstream!:
	g/bin/fetch-upstream

install-hooks!:
	g/bin/install-hooks

pipcet!:
	g/bin/pipcet

pull!:
	g/bin/pull

remotes!:
	g/bin/remotes

find-canonical!:
	g/bin/find-canonical

list-remotes!:
	git remote -v show
	git submodule foreach --recursive git remote -v show

g/remotes.mk: g/remotes.txt g/bin/remotes-mk
	g/bin/remotes-mk > $@

include g/remotes.mk
