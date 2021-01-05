#!/bin/bash

OpenSCAD_lib=~/.local/share/OpenSCAD/libraries
tools=.

if [ -d "$OpenSCAD_lib" ]; then
	if [ -d 	 "$OpenSCAD_lib/tools" ]; then
		rm -r    "$OpenSCAD_lib/tools/"*
	else
		mkdir -p "$OpenSCAD_lib/tools"
	fi
	cp "$tools/tools/"*                   "$OpenSCAD_lib/tools"
	cp "$tools/tools.scad"                "$OpenSCAD_lib"
	cp "$tools/compatibility.scad"        "$OpenSCAD_lib"
	cp "$tools/compatibility_assert.scad" "$OpenSCAD_lib"
else
	echo "OpenSCAD libraries folder not found."
fi
