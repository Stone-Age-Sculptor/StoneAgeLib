// DemonstrationInverseMinkowski.scad
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

// Warning: 
//   This might not run with a 2021 version
//   of OpenSCAD. Please use at least a
//   version of 2025.
//
//   Use this inverse minkowski as a last option.
//   There are libraries that can create smooth shapes
//   with polyhedrons, which is much faster.

$fn = 20;

translate([-20,-10,-5])
  cube([40,20,5]);

translate([-15,-5,0])
  InverseMinkowski(0.8)
    linear_extrude(2)
      text("A",size=10);

InverseMinkowski(1)
  translate([0,-2,-1])
    rotate([-30,0,0])
      cylinder(h=10,r=1);

InverseMinkowski(1)
  translate([10,1,3])
    rotate([-30,0,0])
    {
      difference()
      {
        union()
        {
          cube([1.5,6,14],center=true);
          cylinder(h=12,d=1.2);
          translate([0,0,4])
            cube([8,1,1],center=true);
        }
        cube([5,3,3],center=true);
      }
    }
