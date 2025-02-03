// DemonstrationFont.scad
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
include <StoneAgeLib/font.scad>

$fn = 50;

text_subdivision("Subdivision Font",weight=1.3);

// Show some special characters
translate([0,-15])
  text_subdivision("Ωµ√☺☹♥⇨→éèëê",weight=1.1,spacing=1.5);

translate([0,-30])
  text_subdivision("H₂O  CaCO₃  √(x²+y²)",weight=1.1,spacing=0.8);

translate([0,-45])
  text_subdivision("Italics",slanting=0.5,weight=1.3);
translate([50,-45])
  text_subdivision("More",slanting=1.1,weight=1.3);
translate([100,-45])
  text_subdivision("Backward",slanting=-0.5,weight=1.3);

translate([0,-60])
  text_subdivision("Stencil 0123456789",font="Subdivision Stencil Font",weight=1.0);

translate([0,-75])
  text_subdivision("CLASSIC",font="Subdivision Classic Font",weight=1.5);

// A thin font can be used to create striped text
translate([0,-90])
  Stripes()
    text_subdivision("Hello",weight=0.4,spacing=1.1);

// Coars and fine rendering of the font.
translate([0,-105])
  text_subdivision("Coarse",weight=1.3,method="1path",smooth=1);
translate([60,-105])
  text_subdivision("Smooth",weight=1.3,method="weightedpath",smooth=5);



module Stripes()
{
  // Start with the font itself.
  children(0);

  // Add an outline
  difference()
  {
    offset(0.6)
      children(0);
    offset(0.2)
      children(0);
  }
  
  // Add another outline
  difference()
  {
    offset(1.2)
      children(0);
    offset(0.8)
      children(0);
  }
}
