// DemonstrationCylinder.scad
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
// February 7, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
// Changes:
//   Added an example of a fillet hole in a block.
//
// Version 3
// November 30, 2025
// Only the "StoneAgeLib.scad" is included now.

include <StoneAgeLib/StoneAgeLib.scad>

$fn = 50;

// A cylinder with a fillet at the top and bottom.
// The bottom is at 45 degrees to make it printable without support.
cylinder_fillet(h=25,r=8,fillet=-2,printable=true);

// Two cylinders on a plate with fillet.
// Two spheres and a bar is added to make handle.
translate([30,0,0])
{
  // Make the plate a little higher,
  // to be sure that the cylinders connect.
  translate([-10,-10,-1])
    cube([20,40,1+0.001]);

  cylinder_fillet(h=10,r=2,fillet_bottom=2);

  translate([0,20,0])
    cylinder_fillet(h=10,r=2,fillet_bottom=2);

  hull()
  {
    translate([0,0,10])
      sphere(2);
    translate([0,20,10])
      sphere(2);
  }
}

// A block with a fillet round hole.
thickness_plate = 15;
translate([-30,0,10])
{
  difference()
  {
    // The block.
    cube([20,thickness_plate,20],center=true);

    // Remove a fillet cylinder with outward fillet.
    // The correction of 0.005 is to avoid jitter
    // in the preview.
    rotate([90,0,0])
      cylinder_fillet(h=thickness_plate+0.005,d=10,fillet=3,center=true);
  }
}
