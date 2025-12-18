// DemonstrationChamfer.scad
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
// March 2, 2025
// Changes:
//   Name "linear_extrude_chamfer()" is
//   changed to "chamfer_extrude()".
//   Examples for outward_bevel_extrude() added.
//
// Version 3
// November 30, 2025
// Only the "StoneAgeLib.scad" is included now.

include <StoneAgeLib/StoneAgeLib.scad>

// Please use a OpenSCAD version of 2025 or newer,
// because the roof() function is used for the chamfer.
// A fake roof function is used for older versions,
// which is slow and not good.

$fa = 2;
$fs = 0.5;

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
chamfer_extrude(height=height,chamfer=7)
  offset(delta=d*chamfer,chamfer=true)
    offset(-d*chamfer)
      square([length,width]);

// A chamfered cylinder.
translate([-30,30,0])
  chamfer_extrude(height=50,chamfer=8)
    circle(r=20);

// Chamfered text on the box.
translate([18,22,height-0.001])
  chamfer_extrude(height=3,chamfer_top=1.5)
    text("ABC",size=40);

// Different angles and different sizes
// for top and bottom.
translate([180,0,0])
  chamfer_extrude(height=40,chamfer_top=5,angle_top=20,chamfer_bottom=20,angle_bottom=80)
    square(40);

// Example of outward bevel between two plates.
translate([0,-120])
{
  // The two plates
  color("DarkTurquoise")
  {
    translate([-5,0,0])
      cube([5,80,35]);
    translate([80,0,0])
      cube([5,80,35]);
  }

  // A rectangular rod with round edges.
  color("LightSteelBlue")
    translate([0,33,23])
      rotate([0,90,0])
        outward_bevel_extrude(80,bevel=5)
          Round2D(2)
            square([10,16]);

  // A round rod.
  color("GoldenRod")
    for(y=[8,72],z=[8,27])
      translate([0,y,z])
        rotate([0,90,0])
          outward_bevel_extrude(80,bevel=4)
            circle(d=5);
}

// Example of outward bevel at the bottom of text.
translate([120,-100])
{
  color("SandyBrown")
    cube([110,60,5]);

  color("BurlyWood")
    translate([11,16,5])
      outward_bevel_extrude(10,bevel_bottom=1.5)
        text("ABC",size=30);
}
