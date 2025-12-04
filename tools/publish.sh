#!/bin/sh

make -f tools/Makefile

#rsync -avz *.html gophermap notes pictures files blog uberspace.net:public_html/
rsync -avz *.html gophermap notes pictures files blog thunix.net:public_html/
rsync -avz *.html gophermap notes pictures files blog steady.mooo.com:public_html/
