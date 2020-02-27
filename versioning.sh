#!/bin/bash

# This script looks for current git tag name and inserts it in target file as HTML comments

GIT_COMMAND=(git describe --tags --exact-match)
VERSION=$( "${GIT_COMMAND[@]}" 2>&1 )
FILEPATH=${1}

# Check if file exists
if [ ! -e "$FILEPATH" ]; then
	echo "File does not exist"
	exit 1
fi

# Check if tag exists in git head
if [[ $VERSION == fatal* ]]; then
	VERSION="unknown"
	echo "Git tag is not set for this commit!"
fi

echo "Versioning HTML in $FILEPATH..."
echo "New version is $VERSION"

# Check if version tag exists within file
VERSION_TAG="<\!-- version"
VERSION_LINE="$VERSION_TAG: $VERSION-->"
if grep -q "$VERSION_TAG" "$FILEPATH"; then
	# If exists replace it with new
	sed -i -- "s/$VERSION_TAG.*$/$VERSION_LINE/g" $FILEPATH
else
	# If doesn't exist, insert new one in first line
	sed -i -- '1s/^/'"$VERSION_LINE"'\'$'\n/' $FILEPATH
fi

echo "Versioning completed succesfuly"
