// DemonstrationTurtle.scad
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
include <StoneAgeLib/turtle.scad>

$fn=80;

// Use a turtle to create a wave.
turtle1 = [ [SETHEADING,130], each for(i=[0:6]) [[CIRCLE,-5,260],[CIRCLE,5,260]] ];
path1 = TurtleToPath(turtle1);
translate([-50,-10])
  DrawPath(path1,0.5);

// Use a turtle to create a spring.
turtle2 = [ [LEFT,90], each for(i=[0:12]) [[FORWARD,14],[CIRCLE,-2,180],[FORWARD,14],[CIRCLE,2,180]] ];
path2 = TurtleToPath(turtle2);
translate([-50,-40])
  DrawPath(path2,1.0);

// Use a turtle to make a polygon.
turtle3 =
[
  [LEFT,100],
  [FORWARD,3.2],
  [RIGHT,120],
  [FORWARD,2],
  [LEFT,60],
  [FORWARD,12],
  [CIRCLE,8,110],
  [RIGHT,140],
  [CIRCLE,16,80],
  [RIGHT,130],
  [CIRCLE,16,77],
  [RIGHT,120],
  [CIRCLE,12,90],
  [RIGHT,130],
  [CIRCLE,12,80],
  [RIGHT,130],
  [CIRCLE,12,80],
  [RIGHT,120],
  [CIRCLE,16,80],
  [RIGHT,130],
  [CIRCLE,11.6,123],
  [FORWARD,7.6],
  [LEFT,60],
  [FORWARD,2],
];
path3 = TurtleToPath(turtle3);
translate([-50,10])
  polygon(path3);

// Use a turtle to make a door knob.
turtle4 =
[
  [FORWARD,15],
  [LEFT,180], // reverse direction
  [CIRCLE,-5,160],
  [FORWARD,1],
  [CIRCLE,2.5,160],
  [SETX,0],
];
path4 = TurtleToPath(turtle4);
translate([40,5])
  polygon(path4);
translate([40,40])
  rotate_extrude()
    polygon(path4);


