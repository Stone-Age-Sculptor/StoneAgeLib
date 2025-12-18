// DemonstrationTurtleRecursive.scad
//
// Demonstration for the StoneAgeLib
//
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 1
// February 9, 2025
//
// Version 2
// November 30, 2025
// Only the "StoneAgeLib.scad" is included now.

include <StoneAgeLib/StoneAgeLib.scad>

$fn=50;

// A Turtle to make a fractal with
// a recursive function.
//
// The fractal for a tree is probably
// the most common fractal math.
// Using a Turtle makes it easy, 
// but the Turtle has to move back
// on the branch.
function Branch(distance=10,level=9,angle=20) = 
  level > 0 ? 
  concat(
    [[FORWARD,distance],[RIGHT,angle]],  
    Branch(0.85 * distance, level-1),
    [[LEFT,2*angle]],
    Branch(0.85 * distance, level-1),
    [[RIGHT,angle],[BACKWARD,distance]]) : [];

// Generate the fractal.
// Add a turn to left at the start.
turtle = concat([[LEFT,90]],Branch());
path = TurtleToPath(turtle);
DrawPath(path,width=0.2);
