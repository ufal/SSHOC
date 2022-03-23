#!/bin/awk

BEGIN { JOIN=0; }
/"[^\t]*$/ { JOIN=1; }
/^[^\t]*"\t/ { JOIN=0 }
{ if (JOIN==1) printf "%s ", $0; else print $0 }
