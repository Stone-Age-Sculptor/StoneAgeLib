// DemonstrationFontDesigner.scad
//
// Demonstration for the StoneAgeLib
//
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 1
// February 3, 2025
//
// Version 2
// November 30, 2025
// Only the "StoneAgeLib.scad" is included now.

include <StoneAgeLib/StoneAgeLib.scad>

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
