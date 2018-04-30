#!/bin/sh

# Composes an atom feed out of XHTML files.

BASEDIR=~/homepage
TOOLS="${BASEDIR}/tools"
SOURCES="${BASEDIR}/src"
ATOM="${BASEDIR}/atom.xml"
NOTES="${BASEDIR}/notes"

(echo '<?xml version="1.0" encoding="UTF-8"?>' &&
     echo '<list>' &&
     find "${NOTES}" -name '*.xhtml' |
         # grep -Ev "^(${TOOLS}|${SOURCES}).*" |
         sed -e "sS^${BASEDIR}/\(.*\)S<entry name=\"\\1\" />S" &&
     echo '</list>') |
    xsltproc "${TOOLS}/html-to-atom-dump.xsl" - |
    xsltproc "${TOOLS}/atom-sort.xsl" - |
    xsltproc "${TOOLS}/atom-limit.xsl" - |
    xmllint --format --nsclean - > "${ATOM}"
