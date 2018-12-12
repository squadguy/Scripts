#!/bin/bash

#Set this in your alias file to "google" and then simply enter a quoted string to google anything from your command line.

#Usage: google "What is the weather in Tulsa"

googleIt=`echo $1 | sed 's/ /+/g'`

firefox https://www.google.com/webhp?gws_rd-ssl=#q=$googleIt
