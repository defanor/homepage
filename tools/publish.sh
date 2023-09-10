#!/bin/sh

make -f tools/Makefile

# upload
rsync --exclude '.*' --exclude '*.org' --exclude 'src/' \
      --exclude 'tools/' --exclude 'build/' \
      -avz . tart.uberspace.net:public_html/
