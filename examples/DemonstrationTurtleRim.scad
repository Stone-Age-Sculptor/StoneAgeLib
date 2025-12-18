// DemonstrationTurtleRim.scad
//
// Demonstration for the StoneAgeLib
//
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 1
// February 22, 2025
//
// Version 2
// November 30, 2025
// Only the "StoneAgeLib.scad" is included now.

include <StoneAgeLib/StoneAgeLib.scad>

$fn=200;

// A demonstration of a Turtle for a complex shape.
// The shape is the rim of a car wheel.

turtle =
[
  [FORWARD,10],
  [CIRCLE,1,80],
  [FORWARD,5],
  [CIRCLE,2,10],
  [FORWARD,2],
  [CIRCLE,-1,80],
  [CIRCLE,1,20],
  [CIRCLE,-0.5,200],
  [FORWARD,0.3],
  [CIRCLE,0.5,100],
  [CIRCLE,-1,35],
  [CIRCLE,2,13],
  [FORWARD,4.7],
  [CIRCLE,1,32],
  [CIRCLE,-1,50],
  [CIRCLE,0.5,100],
  [FORWARD,0.3],
  [CIRCLE,-0.5,200],
  [CIRCLE,1,20],
  [CIRCLE,-1,58],
  [CIRCLE,0.3,84],
  [CIRCLE,-45,12],
  [SETX,0],
];

path = TurtleToPath(turtle);

// Show the polygon for the profile.
// Show it only in the preview.
if($preview)
  translate([20,0])
    polygon(path);

// Show the brim.
difference()
{
  translate([0,0,9.26])
    rotate([180,0,0])
      rotate_extrude(convexity=4)
        polygon(path);

  // Remove holes.
  for(i=[0:4])
  {
    rotate(i*360/5)
      linear_extrude(20,convexity=3)
        hull()
        {
          translate([7,0])
            circle(3.5);
          translate([4.4,0])
            circle(2.0);
        }
    rotate((i+0.5)*360/5)
      translate([1.6,0,0])
        cylinder(h=20,d=0.7);
  }
}
