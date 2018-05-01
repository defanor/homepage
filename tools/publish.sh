#!/bin/sh

BASEDIR=~/homepage
TOOLS="${BASEDIR}/tools"
BUILD="${BASEDIR}/build"
ATOM="${BASEDIR}/atom.xml"
SOURCES="${BASEDIR}/src"
NOTES="${SOURCES}/notes"


# dump all the notes into a single file
(echo '<?xml version="1.0" encoding="UTF-8"?>' &&
     echo '<notes>' &&
     find "${NOTES}" -name '*.xhtml' |
         grep -v index.xhtml |
         sed -e "sS^${SOURCES}/\(.*\)S  <note src=\"\\1\" />S" &&
     echo '</notes>') |
    xsltproc -o "${BUILD}/notes-dump.xml" "${TOOLS}/xml-notes-dump.xsl" -

# sort by publication and modification dates
xsltproc -o "${BUILD}/notes-by-publication-date.xml" \
         "${TOOLS}/xml-notes-sort.xsl" "${BUILD}/notes-dump.xml"
xsltproc -o "${BUILD}/notes-by-modification-date.xml" \
         --stringparam sortBy modified \
         "${TOOLS}/xml-notes-sort.xsl" "${BUILD}/notes-dump.xml"

# create an atom feed with the most recently modified 10 entries
xsltproc --param number 10 "${TOOLS}/xml-notes-limit.xsl" \
         "${BUILD}/notes-by-modification-date.xml" |
    xsltproc -o "${ATOM}" "${TOOLS}/xml-notes-to-atom.xsl" -

# convert sources into XHTML
find "${SOURCES}" -name '*.xhtml' |
    sed -e "sS^${SOURCES}SS" |
    xargs -Ifile xsltproc -o "${BASEDIR}/file" \
          "${TOOLS}/xml-to-html.xsl" "${SOURCES}file"

# upload
rsync --exclude '.*' --exclude '*.org' --exclude 'src/' \
      --exclude 'tools/' --exclude 'build/' \
      -avz . uberspace.net:homepage/web/
