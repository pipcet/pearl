#!/bin/bash
BASENAME="$(echo "$1" | sed -e 's/.*\///')"
echo "#!/bin/bash"
bash ./host/pack/pack.bash '~/tmp' "$1" "./host/pack/pack.bash"
echo "tar cf ~/tmp/wifi.tar /usr/share/firmware/wifi"
echo 'SHA=$(sha512sum ~/tmp/'"$BASENAME"')'
echo "bash ~/tmp/pack.bash --zsh /persist/ ~/tmp/wifi.tar >> ~/tmp/$BASENAME"
# echo "echo SHA-512 of $BASENAME is \$SHA. Please verify. It should be $(sha512sum "$1"), but should also match the SHA-512 printed on the download page."
echo "kmutil configure-boot -c ~/tmp/$BASENAME -v /Volumes/Macintosh\ HD/ </dev/stdout && reboot"
echo "echo \"Since we got here, something went wrong. Did you disable boot security using bputil and csrutil?\""
