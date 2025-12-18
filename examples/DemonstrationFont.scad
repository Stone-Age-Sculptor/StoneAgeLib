// DemonstrationFont.scad
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
// February 22, 2025
// Changes:
//   The parameter "slanting" is now called "slant".
//   Show lower case classic font.
//
// Version 3
// December 12, 2025
// Changes:
//   Only the "StoneAgeLib.scad" is included now.
//   The method "weightedpath" is now called "cubicpath".

include <StoneAgeLib/StoneAgeLib.scad>

$fn = 50;

text_subdivision("Subdivision Font",weight=1.3);

// Show some special characters
translate([0,-15])
  text_subdivision("Ωµπ√☺☹♥⇨→éèëê",weight=1.1,spacing=1.5);

translate([0,-30])
  text_subdivision("H₂O  CaCO₃  √(x²+y²)",weight=1.1,spacing=0.8);

translate([0,-45])
  text_subdivision("Italics",slant=0.5,weight=1.3);
translate([50,-45])
  text_subdivision("More",slant=1.1,weight=1.3);
translate([100,-45])
  text_subdivision("Backward",slant=-0.5,weight=1.3);

translate([0,-60])
  text_subdivision("Stencil 0123456789",font="Subdivision Stencil Font",weight=1.0);

translate([0,-75])
  text_subdivision("CLASSIC classic",font="Subdivision Classic Font",weight=1.5);

// Shows that a offset has the same result as width.
translate([0,-90])
  text_subdivision("Test (weight=2)",weight=1.5);
translate([0,-105])
  offset(0.75)
    text_subdivision("Test (offset=1)",weight=0.001);

// A thin font can be used to create striped text
translate([0,-120])
  Stripes()
    text_subdivision("Hello",weight=0.4,spacing=1.1);

// Coars and fine rendering of the font.
translate([0,-135])
  text_subdivision("Coarse",weight=1.3,method="1path",smooth=1);
translate([60,-135])
  text_subdivision("Smooth",weight=1.3,method="cubicpath",smooth=5);

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
