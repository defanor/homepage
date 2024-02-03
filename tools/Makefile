all: $(patsubst src/%,%,$(wildcard src/notes/*.xhtml src/*.xhtml)) \
	notes/atom.xml

# Index page
index.xhtml: src/index.xhtml build/notes-by-modification-date.xml tools/xml-to-html.xsl
	xsltproc -o $@ tools/xml-to-html.xsl $<

# Note index page
notes/index.xhtml: src/notes/index.xhtml build/notes-by-publication-date.xml tools/xml-to-html.xsl
	xsltproc -o $@ tools/xml-to-html.xsl $<

# Notes
notes/%.xhtml: src/notes/%.xhtml tools/xml-to-html.xsl
	xsltproc -o $@ tools/xml-to-html.xsl $<

# Other static pages
%.xhtml: src/%.xhtml tools/xml-to-html.xsl
	xsltproc -o $@ tools/xml-to-html.xsl $<

# A single-file dump of all notes
build/notes-dump.xml: src/notes/*.xhtml tools/xml-notes-dump.xsl
	(echo '<?xml version="1.0" encoding="UTF-8"?>' && \
		echo '<notes>' && \
		find src/notes -name '*.xhtml' | \
		grep -v index.xhtml | \
		sed -e "sS^src/\(.*\)S  <note src=\"\\1\" />S" && \
		echo '</notes>') | \
		xsltproc -o $@ tools/xml-notes-dump.xsl -

# Notes sorted by publication date
build/notes-by-publication-date.xml: build/notes-dump.xml tools/xml-notes-sort.xsl
	xsltproc -o $@ tools/xml-notes-sort.xsl build/notes-dump.xml

# Notes sorted by modification date
build/notes-by-modification-date.xml: build/notes-dump.xml tools/xml-notes-sort.xsl
	xsltproc -o $@ --stringparam sortBy modified \
		tools/xml-notes-sort.xsl build/notes-dump.xml

# An Atom feed
notes/atom.xml: build/notes-by-modification-date.xml tools/xml-notes-limit.xsl tools/xml-notes-to-atom.xsl
	xsltproc --param number 10 tools/xml-notes-limit.xsl \
		build/notes-by-modification-date.xml | \
		xsltproc -o $@ tools/xml-notes-to-atom.xsl -
