// DemonstrationPerspective.scad
//
// Demonstration for the StoneAgeLib
//
// Version 1
// February 22, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)

// Either include everything with
// the file StoneAgeLib.scad, or
// include only what is needed.

//include <StoneAgeLib/StoneAgeLib.scad>
include <StoneAgeLib/perspective.scad>

$fn=50;

// Print the text with perspective.
color("Navy")
  Perspective(0.4,40)  // strength, vanishing point on y-axis
    FullText();

// Draw a box, to show that it is really a perspective text.
color("Coral")
  translate([0,24,-1.1])
    difference()
    {
      square([155,56],center=true);
      square([154,55],center=true);
    }

// Multiple lines of text.
module FullText()
{
  line_offset = 20;

  Centered(6,"In a world, not far away,");
  Centered(5,"there was one parametric modeler");
  Centered(4,"that stood against many mesh modelers.");
  Centered(3,"It created a new dimension which can");
  Centered(2,"be entered via a downloadable portal.");
  Centered(1,"Go to openscad.org to download your own doorway");
  Centered(0,"into the amazing world of parametric 3D design.");

  module Centered(line,string)
  {
    translate([0,line*line_offset])
      text(string,halign="center");
  }
}
