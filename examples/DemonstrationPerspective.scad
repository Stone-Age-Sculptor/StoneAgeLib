// DemonstrationPerspective.scad
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
// March 2, 2025
// Changes:
//   A second example added with shadow.
//
// Version 3
// December 12, 2025
// Changes:
//   Only the "StoneAgeLib.scad" is included now.
//   The method "weightedpath" is now called "cubicpath".

include <StoneAgeLib/StoneAgeLib.scad>

$fn=50;

// Print text with perspective.
// The default font of OpenSCAD is used.
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


// A 2D example with the combination of:
//   * Subdivision font (from the library)
//   * Shadow           (from the library)
//   * Perspective      (from the library)
translate([0,-30])
{
  color("CornFlowerBlue")
    Perspective(0.5,25)
      Shape2D();
  color("Black")
    Perspective(0.5,25)
      Shadow2D(length=5,angle=-90)
        Shape2D();
}

// This module is used to show the text,
// and it is used to make the shadow.
module Shape2D()
{
  translate([-108,0])
    text_subdivision(
      "Control Room",
      font="Subdivision Classic Font",
      size=20,
      weight=1.8,
      spacing=1.2,
      smooth=4,
      method="cubicpath");
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
