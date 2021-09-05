#!/bin/sh
echo "#!/bin/bash"
NONCE=
for i in $(seq 1 8); do
    NONCE=$NONCE$(printf "%04x" $RANDOM)
done
echo head -c $(wc -c < $1) '>' "/persist/$(basename $1)" '<<"'$NONCE'"'
cat $1
echo
echo $NONCE
