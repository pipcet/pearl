$ git clone https://github.com/pipcet/g
$ cd g
$ git submodule update --init --recursive
$ ./g/bin/pipcet
$ ./g/bin/install-hooks
$ ./g/bin/remotes
$ while ! ./g/bin/gather-remotes  | ./g/bin/fix-remotes | ./g/bin/install-remotes; do sleep 1; done
$ ./g/bin/canonical
$ ./g/bin/add-self-remotes
