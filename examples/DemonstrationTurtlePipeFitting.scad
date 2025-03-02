// DemonstrationTurtlePipeFitting.scad
//
// Demonstration for the StoneAgeLib
//
// Version 1
// March 2, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)

// Either include everything with
// the file StoneAgeLib.scad, or
// include only what is needed.

//include <StoneAgeLib/StoneAgeLib.scad>
include <StoneAgeLib/turtle.scad>

$fn=80;

// A demonstration of a Turtle for a profile.

turtle =
[
  [FORWARD,4],
  [LEFT,45],
  [FORWARD,0.2],      
  [LEFT,45],
  [FORWARD,0.6],
  [LEFT,45],
  [FORWARD,0.2],
  [LEFT,45],
  [FORWARD,1.6],
  [CIRCLE,-1.6,90],
  [FORWARD,3],
  [RIGHT,45],
  [FORWARD,0.5],
  [CIRCLE,0.2,45],
  [FORWARD,0.8],
  [CIRCLE,0.2,90],
  [SETX,0],
];

path = TurtleToPath(turtle);

// Show the polygon for the profile.
// Show it only in the preview.
if($preview)
  color("SlateBlue")
    translate([10,0])
      polygon(path);

// Show the pipe connector.
difference()
{
  rotate_extrude(convexity=4)
    translate([3,0])
      polygon(path);

  // Remove holes.
  for(i=[0:4])
  {
    rotate(i*360/5)
      linear_extrude(5,convexity=3,center=true)
        translate([6,0])
          circle(0.5);
  }
}
