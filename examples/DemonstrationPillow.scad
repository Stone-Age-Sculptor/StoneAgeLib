// DemonstrationPillow.scad
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
include <StoneAgeLib/extrude.scad>

$fn = 50;

// Use at least a 2025 version of OpenSCAD.
// This will not run with a 2021 version of OpenSCAD.
//
// The library function pillow(), and this example are
// by Reddit user oldesole1, license CC0.
// Origin: https://www.reddit.com/r/openscad/comments/1h717if/pillowing_using_roof


pillow([2, 0.5], 10)
  shape();

module shape() 
{
  for(a = [1:3])
    rotate(120 * a)
      translate([0, 11])
         circle(10);
}
