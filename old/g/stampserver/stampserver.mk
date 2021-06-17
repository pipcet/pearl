stamp/%: | stamp/
	touch $@

# echo $((1024*1024)) | sudo tee /proc/sys/fs/inotify/max_user_watches
stampserver: g/stampserver/stampserver.pl | stamp/
	inotifywait -m -r . | perl g/stampserver/stampserver.pl
