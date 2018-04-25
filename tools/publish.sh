#!/bin/sh

TOOLS=~/homepage/tools

${TOOLS}/xml-to-html.sh
${TOOLS}/html-to-atom.sh
rsync --exclude '.*' --exclude '*.org' --exclude 'src/' --exclude 'tools/' \
      -avz . uberspace.net:homepage/web/
