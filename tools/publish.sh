#!/bin/sh

make -f tools/Makefile

rsync -avz *.xhtml notes pictures files uberspace.net:public_html/
rsync -avz *.xhtml notes pictures files thunix.net:public_html/
