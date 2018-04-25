#!/bin/sh

# Translates simplified documents from src/

BASEDIR=~/homepage
TOOLS="${BASEDIR}/tools"
SOURCES="${BASEDIR}/src"

find "${SOURCES}" -name '*.xhtml' |
    sed -e "sS^${SOURCES}SS" |
    xargs -Ifile xsltproc -o "${BASEDIR}/file" \
          "${TOOLS}/xml-to-html.xsl" "${SOURCES}file"
