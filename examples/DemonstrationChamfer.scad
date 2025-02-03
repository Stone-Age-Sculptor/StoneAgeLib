// DemonstrationChamfer.scad
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

// Please use a OpenSCAD version of 2025 or newer,
// because the roof() function is used for the chamfer.
// A fake roof function is used for older versions,
// which is slow and not good.

$fa = 5;
$fs = 2;

// A chamfered box.
// measurements of the box.
length = 150;
width  = 80;
height = 20;

// chamfer for all edges.
chamfer = 5;

// Use a offset for the corners,
// and the function for the chamfered top and bottom.
d = 1 + sqrt(2)/2;
linear_extrude_chamfer(height=height,chamfer=7)
  offset(delta=d*chamfer,chamfer=true)
    offset(-d*chamfer)
      square([length,width]);

// A chamfered cylinder.
translate([-30,30,0])
  linear_extrude_chamfer(height=50,chamfer=8)
    circle(r=20);

// Chamfered text on the box.
translate([18,22,height-0.001])
  linear_extrude_chamfer(height=3,chamfer_top=1.5)
    text("ABC",size=40);

// Different angles and different sizes
// for top and bottom.
translate([180,0,0])
  linear_extrude_chamfer(height=40,chamfer_top=5,angle_top=20,chamfer_bottom=20,angle_bottom=80)
    square(40);

