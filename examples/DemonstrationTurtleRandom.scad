// DemonstrationTurtleRandom.scad
//
// Demonstration for the StoneAgeLib
//
// Version 1
// February 13, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)

// Either include everything with
// the file StoneAgeLib.scad, or
// include only what is needed.

//include <StoneAgeLib/StoneAgeLib.scad>
include <StoneAgeLib/turtle.scad>

$fn=80;

// A demonstration of a Turtle with random.

color("Green")
  for(x=rands(0,40,5))
    translate([x,0])
      for(i=[0:10])
      {
        n = 5;
        turtle =
        [
          [LEFT,90],
          for(i=[0:20]) [CIRCLE,rands(-5,5,1)[0],rands(0,i/n*12,1)[0]],
        ];
        path = TurtleToPath(turtle);
        DrawPath(path,0.1);
      }
