#!/bin/sh

make -f tools/Makefile

rsync -avz *.xhtml gophermap notes pictures files blog uberspace.net:public_html/
rsync -avz *.xhtml gophermap notes pictures files blog thunix.net:public_html/
