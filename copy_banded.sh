#!/bin/bash

OpenSCAD_lib=~/.local/share/OpenSCAD/libraries
folder=.

if [ -d "$OpenSCAD_lib" ]; then
	if [ -d 	 "$OpenSCAD_lib/banded" ]; then
		rm -r    "$OpenSCAD_lib/banded/"*
	else
		mkdir -p "$OpenSCAD_lib/banded"
	fi
	cp -r "$folder/banded/"*    "$OpenSCAD_lib/banded"
	cp    "$folder/banded.scad" "$OpenSCAD_lib"
	cp    "$folder/antiquity/"* "$OpenSCAD_lib"
else
	echo "OpenSCAD libraries folder not found."
fi
