#!/bin/bash
# This script is designed to fix Spotlight indexing issues
# by removing the existing Spotlight index and forcing Spotlight
# to create a new search index.

echo Turning Spotlight indexing off

/usr/bin/mdutil -i off /

echo  Deleting the Spotlight folder on the root level of the boot volume

/bin/rm -rf /.Spotlight*

echo Turning Spotlight indexing on

/usr/bin/mdutil -i on /

echo Forcing Spotlight re-indexing on the boot volume

/usr/bin/mdutil -E /