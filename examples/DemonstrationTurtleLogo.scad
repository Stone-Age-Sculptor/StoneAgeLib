// DemonstrationTurtleLogo.scad
//
// Demonstration for the StoneAgeLib
//
// Version 1
// February 10, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)

// Either include everything with
// the file StoneAgeLib.scad, or
// include only what is needed.

//include <StoneAgeLib/StoneAgeLib.scad>
include <StoneAgeLib/font.scad>
include <StoneAgeLib/shadow.scad>

$fn=50;

// The "Turtle" part of the StoneAgeLib has
// its own logo, made with the library.
//
// The result is not in 2D, but in 3D to
// make use of the better rendering.

// White background.
color("White")
  translate([-10,-10,-0.9])
    linear_extrude(1)
      square([40,30]);

// Green turtle
color("Green")
  linear_extrude(1)
    Shape2D();

// Dark green shadow.
// But shift the shadow for an artistic effect.
color("Blue")
  translate([0.1,-0.1,0])
    linear_extrude(0.4)
      Shadow2D(length=0.4)
        Shape2D();

// Light green highlight
color("LawnGreen")
  translate([0,0,1-0.001])
    linear_extrude(0.2)
      Shadow2D(length=0.2,highlight=true)
        Shape2D();

// The turtle emoticon is created
// in the Subdivision Font.
module Shape2D()
{
  text_subdivision("🐢",weight=0.5,method="weightedpath",smooth=4);
}
