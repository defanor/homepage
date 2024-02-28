all: $(patsubst src/%,%,$(wildcard src/notes/*.xhtml src/*.xhtml)) \
	notes/atom.xml blog/index.xhtml blog/gophermap gophermap

# Index page
index.xhtml: src/index.xhtml build/notes-by-modification-date.xml build/blog.xml tools/xml-to-html.xsl
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

# Blog and phlog indexes. Assuming that the blog post file names are
# prefixed with dates in a format that makes sense to sort in the
# lexiographic order.
blog/index.xhtml: src/blog/index.xhtml build/blog.xml tools/xml-to-html.xsl
	xsltproc -o $@ tools/xml-to-html.xsl $<

build/blog.xml: blog/*.txt
	(echo '<?xml version="1.0" encoding="UTF-8"?>' && \
		echo '<files>' && \
		ls -r blog/*.txt | \
		sed -e "sS^blog/\(.*\)S  <file src=\"\\1\" />S" && \
		echo '</files>') \
	> build/blog.xml

blog/gophermap: blog/*.txt
	(echo "!defanor's phlog" && \
	ls -r blog/*.txt | \
	sed -e "sS^blog/\(.*\)S0\\1\t\\1S" && \
	echo '.') \
	> $@

gophermap: src/gophermap.m4 blog/*.txt
	m4 src/gophermap.m4 > $@

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
