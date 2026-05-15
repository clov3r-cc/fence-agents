#!/usr/bin/bash

set -e

BUILD_DIR=/tmp/build
echo "### Copying source to $BUILD_DIR"
mkdir -p "$BUILD_DIR"
cp -a /code/. "$BUILD_DIR"
cd "$BUILD_DIR"

echo "### Running autogen"
./autogen.sh

CONFIGURE_FLAGS=""
if [ -n "$AGENT" ]; then
    CONFIGURE_FLAGS="--with-agents=$AGENT"
fi

echo "### Running configure $CONFIGURE_FLAGS"
./configure $CONFIGURE_FLAGS

make -C lib

if [ -n "$AGENT" ]; then
    make -C agents "$AGENT/fence_$AGENT"
else
    make
fi

OUTPUT_DIR=/output
if [ -d "$OUTPUT_DIR" ]; then
    if [ -n "$AGENT" ]; then
        echo "### Building standalone binary with PyInstaller"
        PYTHONPATH=lib pyinstaller --onefile --distpath /tmp/dist \
            "agents/$AGENT/fence_$AGENT" > /dev/null 2>&1
        cp "/tmp/dist/fence_$AGENT" "$OUTPUT_DIR/"
        echo "### Done. Standalone binary in $OUTPUT_DIR/fence_$AGENT"
    else
        echo "### Copying built agents to $OUTPUT_DIR"
        find agents -maxdepth 2 -type f -name 'fence_*' ! -name '*.*' \
            -exec cp {} "$OUTPUT_DIR" \;
        echo "### Done."
    fi
fi
