#!/bin/sh
QUOTE='"'
if [ "x$1" = "x--zsh" ]; then
    shift;
    echo "#!/bin/zsh"
else
    echo "#!/bin/bash"
fi
NONCE=
for i in 1 2 3 4 5 6 7 8; do
    NONCE=$NONCE$(printf "%04x" $RANDOM)
done
DIR="$1"
shift;
for FILE; do
    BASENAME="$(echo "$FILE" | sed -e 's/.*\///')"
    echo mkdir -p "$DIR"
    echo head -c $(wc -c < $FILE) '>' "$DIR/$BASENAME" '<<'"$QUOTE$NONCE$QUOTE"
    cat $FILE
    echo
    echo $NONCE
done
