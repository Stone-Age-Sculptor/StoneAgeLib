// DemonstrationFontDesigner.scad
//
// Demonstration for the StoneAgeLib
//
// Version 1
// February 3, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)

// Either include everything with
// the file StoneAgeLib.scad, or
// include only what is needed.

//include <StoneAgeLib/StoneAgeLib.scad>
include <StoneAgeLib/font.scad>

$fn = 50;

// The function "FontDesigner()" is used
// to design the font.

offset = 160;

translate([0*offset,0])
  FontDesigner("Subdivision Font");

translate([1*offset,0])
  FontDesigner("Subdivision Stencil Font");

translate([2*offset,0])
  FontDesigner("Subdivision Classic Font");

translate([3*offset,0])
  FontDesigner("Subdivision Handwriting Font");
