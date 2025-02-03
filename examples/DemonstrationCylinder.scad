// DemonstrationCylinder.scad
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
include <StoneAgeLib/shapes.scad>

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
