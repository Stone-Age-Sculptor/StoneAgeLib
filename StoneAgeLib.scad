// StoneAgeLib.scad
//
// Part of the StoneAgeLib
//
// Version 1
// February 3, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 2
// February 4, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain).
// Changes:
//   The function pillow() is removed from extrude.scad
//   The file DemonstrationPillow.scad is removed.
//   It was made by Reddit user oldesole1, but he is working on it himself to improve it.
//
// Version 3
// March 2, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain).
// Changes:
//   Perspective function added.
//   Demonstration for 3D tubes added.
//   Example for cylinder_fillet now also shows a fillet hole.
//   Added "center" parameter to cylinder_fillet().
//   Added file: DemonstrationTurtleRecursive.scad.
//   Added file: DemonstrationTurtleLogo.scad.
//
// Version 4
// March 2, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain).
// Changes:
//   Added 7-segment display.
//   File interpolate.scad is now called subdivision.scad
//   Module outward_bevel_extrude() added.
//   Updates to font.
//   Name "linear_extrude_chamfer()" is
//   changed to "chamfer_extrude()".
//
// Version 5
// June 4, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain).
// Changes:
//   Added MirrorList(v,list).
//   Removed most global variables.
//   vector_add_2D() is renamed to vector_add() and is now for 2D and 3D.
//
// Version 6
// September 9, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain).
// Changes:
//   MakeFrame() added to extrude.scad.
//   The roof() function is no longer needed for the crease texture.
//   Function SteelPlate() added to texture.scad.
//   Function substr() added to string.scad.
//   Bug fix: replaced "\'" with "'" in font.scad.
//
// This version number is the overall version for the whole library.
// Each file has its own version and sometimes there are
// modules and function inside a file with their own version.

// To use this library, either include this file (StoneAgeLib.scad) or 
// include the file or files that are used.
// If you make a project with this library, then please add a copy 
// of this library to your project or copy the used functions into your
// own script. The modules and functions of this library may change.

// This library uses a OpenSCAD version of at least 2025.

// The overall version of the library.
VERSION_STONEAGELIB = 6;

include <color.scad>
include <extrude.scad>
include <font.scad>
include <inverseminkowski.scad>
include <list.scad>
include <perspective.scad>
include <seven_segment.scad>
include <shadow.scad>
include <shapes.scad>
include <string.scad>
include <subdivision.scad>
include <tangentlines.scad>
include <texture.scad>
include <turtle.scad>

